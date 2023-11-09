# frozen_string_literal: true

module Diffend
  # Module responsible for building local context
  module LocalContext
    # Module responsible for building packages information from local context
    class Packages
      # Definition of a local path, if it matches it means that we are the source
      ME_PATH = '.'
      # Sources that we expect to match ourselves too
      ME_SOURCES = [
        ::Bundler::Source::Gemspec,
        ::Bundler::Source::Path
      ].freeze
      # List of dependency types
      DEPENDENCIES_TYPES = {
        direct: 0,
        dependency: 1
      }.freeze
      # List of sources types
      SOURCES_TYPES = {
        valid: 0,
        multiple_primary: 1
      }.freeze
      # List of gem sources types
      GEM_SOURCES_TYPES = {
        local: 0,
        gemfile_source: 1,
        gemfile_git: 2,
        gemfile_path: 3
      }.freeze

      class << self
        # @param command [String] command executed via bundler
        # @param definition [::Bundler::Definition] definition for your source
        def call(command, definition)
          instance = new(command, definition)

          ::Bundler.ui.silence { instance.resolve }

          case command
          when Commands::INSTALL, Commands::EXEC, Commands::SECURE, Commands::UPDATE, Commands::ADD then instance.build
          else
            raise ArgumentError, "invalid command: #{command}"
          end
        end
      end

      # @param command [String] command executed via bundler
      # @param definition [::Bundler::Definition] definition for your source
      #
      # @return [Hash] local dependencies
      def initialize(command, definition)
        @command = command
        @definition = definition
        @direct_dependencies = Hash[definition.dependencies.map { |val| [val.name, val] }]
        # Support case without Gemfile.lock
        @locked_specs = @definition.locked_gems ? @definition.locked_gems.specs : []
        @cached = command == Commands::EXEC
      end

      # Resolve definition
      def resolve
        @cached ? @definition.resolve_with_cache! : @definition.resolve_remotely!

        # Despite bundler not materializing resolution, we always need to do so to get all the
        # gems details
        @definition.specs
      end

      # Build specification
      #
      # @return [Hash]
      def build
        hash = build_main

        @definition.resolve.each do |spec|
          # Skip metadata
          next if spec.instance_variable_get(:@specification).nil?
          next if skip?(spec.source)

          locked_spec = @locked_specs.find { |s| s.name == spec.name }

          hash['dependencies'][spec.name] = {
            'platform' => build_spec_platform(spec, locked_spec),
            'source' => build_spec_source(spec),
            'type' => build_dependency_type(spec.name),
            'versions' => build_versions(spec, locked_spec)
          }
        end

        hash
      end

      private

      # Build default specification
      #
      # @return [Hash]
      def build_main
        {
          'dependencies' => {},
          'plugins' => {},
          'sources' => build_sources,
          'platforms' => @definition.platforms.map(&:to_s)
        }
      end

      # Build gem versions
      #
      # @param spec [::Bundler::StubSpecification, ::Bundler::LazySpecification, Gem::Specification]
      # @param locked_spec [::Bundler::LazySpecification, Gem::Specification, NilClass]
      #
      # @return [Array<String>]
      def build_versions(spec, locked_spec = nil)
        if locked_spec && locked_spec.version.to_s != spec.version.to_s
          [locked_spec.version.to_s, spec.version.to_s]
        else
          [spec.version.to_s]
        end
      end

      # @param specs [Array] specs that are direct dependencies
      # @param name [String] spec name
      #
      # @return [Boolean] dependency type
      def build_dependency_type(name)
        if @direct_dependencies.key?(name)
          DEPENDENCIES_TYPES[:direct]
        else
          DEPENDENCIES_TYPES[:dependency]
        end
      end

      # Build gem platform
      #
      # @param spec [::Bundler::StubSpecification, ::Bundler::LazySpecification, Gem::Specification]
      # @param locked_spec [::Bundler::LazySpecification, Gem::Specification, NilClass]
      #
      # @return [String]
      def build_spec_platform(spec, locked_spec)
        parse_platform(
          spec.platform || locked_spec&.platform || spec.send(:generic_local_platform)
        )
      end

      # Parse gem platform
      #
      # @param platform [String, Gem::Platform]
      #
      # @return [String]
      def parse_platform(platform)
        case platform
        when String then platform
        when Gem::Platform then platform.to_s
        end
      end

      # Build gem source type
      #
      # @param source [::Bundler::Source] gem source type
      #
      # @return [Integer] internal gem source type
      def build_spec_gem_source_type(source)
        case source
        when ::Bundler::Source::Metadata
          GEM_SOURCES_TYPES[:local]
        when ::Bundler::Source::Rubygems, ::Bundler::Source::Rubygems::Remote
          GEM_SOURCES_TYPES[:gemfile_source]
        when ::Bundler::Source::Git
          GEM_SOURCES_TYPES[:gemfile_git]
        when ::Bundler::Source::Path
          GEM_SOURCES_TYPES[:gemfile_path]
        else
          raise ArgumentError, "unknown source #{source.class}"
        end
      end

      # Build gem source
      #
      # @param spec [::Bundler::StubSpecification, ::Bundler::LazySpecification, Gem::Specification]
      #
      # @return [Hash]
      def build_spec_source(spec)
        source = source_for_spec(spec)

        {
          'type' => build_spec_gem_source_type(source),
          'value' => source_name_from_source(source)
        }
      end

      # Figure out source for gem
      #
      # @param spec [::Bundler::StubSpecification, ::Bundler::LazySpecification, Gem::Specification]
      #
      # @return [::Bundler::Source] gem source type
      def source_for_spec(spec)
        return spec.remote if spec.remote

        case spec.source
        when ::Bundler::Source::Rubygems
          ::Bundler::Source::Rubygems::Remote.new(spec.source.remotes.last)
        when ::Bundler::Source::Metadata, ::Bundler::Source::Git, ::Bundler::Source::Path
          spec.source
        else
          raise ArgumentError, "unknown source #{spec.source.class}"
        end
      end

      # Build gem source name
      #
      # @param source [::Bundler::Source] gem source type
      #
      # @return [String]
      def source_name_from_source(source)
        case source
        when ::Bundler::Source::Metadata
          ''
        when ::Bundler::Source::Rubygems::Remote
          source_name(source.anonymized_uri)
        when ::Bundler::Source::Git
          source.instance_variable_get(:@safe_uri)
        when ::Bundler::Source::Path
          source.path
        else
          raise ArgumentError, "unknown source #{source.class}"
        end
      end

      # @param uri [::Bundler::URI]
      #
      # @return [String]
      def source_name(uri)
        uri.to_s[0...-1]
      end

      # Build sources used in the Gemfile
      #
      # @return [Array<Hash>]
      def build_sources
        sources = @definition.send(:sources).rubygems_sources
        hash = {}

        sources.each do |source|
          type = build_source_type(source.remotes)

          source.remotes.each do |src|
            hash[source_name(src)] = type
          end
        end

        hash.map { |name, type| { 'name' => name, 'type' => type } }
      end

      # Build gem source type
      #
      # @param remotes [Array<::Bundler::URI>]
      #
      # @return [Integer] internal source type
      def build_source_type(remotes)
        remotes.count > 1 ? SOURCES_TYPES[:multiple_primary] : SOURCES_TYPES[:valid]
      end

      # Checks if we should skip a source
      #
      # @param source [::Bundler::Source] gem source type
      #
      # @return [Boolean] true if we should skip this source, false otherwise
      def skip?(source)
        return true if me?(source)

        false
      end

      # Checks if it's a self source, this happens for repositories that are a gem
      #
      # @param source [::Bundler::Source] gem source type
      #
      # @return [Boolean] true if it's a self source, false otherwise
      def me?(source)
        return false unless ME_SOURCES.include?(source.class)

        source.path.to_s == ME_PATH
      end
    end
  end
end
