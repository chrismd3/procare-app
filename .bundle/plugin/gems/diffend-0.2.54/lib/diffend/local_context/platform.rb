# frozen_string_literal: true

module Diffend
  # Module responsible for building local context
  module LocalContext
    # Module responsible for building platform information from local context
    module Platform
      class << self
        # Build platform information
        #
        # @return [Hash]
        def call
          {
            'bundler' => {
              'version' => ::Bundler::VERSION
            },
            'environment' => environment,
            'ruby' => ruby_information,
            'rubygems' => {
              'specification_version' => Gem::Specification::CURRENT_SPECIFICATION_VERSION,
              'version' => Gem::VERSION
            }
          }.freeze
        end

        private

        # Build platform ruby information
        #
        # @return [Hash]
        def ruby_information
          if defined?(JRUBY_VERSION)
            revision = JRUBY_REVISION.to_s
            version = JRUBY_VERSION
          else
            revision = RUBY_REVISION.to_s
            version = RUBY_ENGINE_VERSION
          end

          {
            'engine' => RUBY_ENGINE,
            'patchlevel' => RUBY_PATCHLEVEL,
            'release_date' => RUBY_RELEASE_DATE,
            'revision' => revision,
            'version' => version
          }
        end

        # Build platform environment information
        #
        # @return [String]
        def environment
          ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
        end
      end
    end
  end
end
