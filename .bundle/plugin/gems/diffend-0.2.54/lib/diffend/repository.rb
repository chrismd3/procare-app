# frozen_string_literal: true

%w[
  tmpdir
  securerandom
].each(&method(:require))

module Diffend
  # Repository for specs
  class Repository
    # Repositories path
    REPOSITORIES_PATH = File.join(
      File.expand_path('..', Bundler.bin_path),
      'repositories'
    ).freeze
    # List of supported repositories split by command
    SUPPORTED = {
      'install' => %w[
        with_gemfile_lock
        with_gemfile_lock_with_added_gem
        with_gemfile_lock_with_changed_gem_version
        with_gemfile_lock_with_locked_gem_version
        with_gemfile_lock_with_removed_gem
        with_gemfile_lock_with_two_platforms
        with_gemfile_lock_with_two_primary_sources
        with_gemfile_lock_with_two_sources
        without_gemfile_lock
      ].freeze,
      'update' => %w[
        with_gemfile_lock
        with_gemfile_lock_with_added_gem
        with_gemfile_lock_with_removed_gem
        with_gemfile_lock_with_two_primary_sources
        with_gemfile_lock_with_two_sources
        without_gemfile_lock
      ].freeze
    }.freeze

    attr_reader :name, :path

    # @param command [String] command executed via bundler
    # @param name [String] repository name
    def initialize(command, name)
      @command = command
      @name = name
      @path = File.join(Dir.tmpdir, SecureRandom.uuid)
    end

    # Build repository path
    #
    # @return [String]
    def orig_path
      @orig_path ||= global_file_path(
        File.join(
          bundler_version_string,
          "#{@command}_#{name}"
        )
      )
    end

    # Setup an isolated instance of a repository
    def setup
      FileUtils.cp_r(orig_path, path)
    end

    # Clean isolated instance of a repository
    def clean
      FileUtils.rm_rf(path)
    end

    # Execute tasks in an isolated instance of a repository
    def isolate
      setup
      yield(path)
      clean
    end

    # Build the path to a specified file within the repository
    #
    # @param file_name [String]
    #
    # @return [String]
    def file_path(file_name)
      File.join(
        path,
        file_name
      )
    end

    # Build global path
    #
    # @param file_name [String]
    #
    # @return [String]
    def global_file_path(file_name)
      File.join(
        REPOSITORIES_PATH,
        file_name
      )
    end

    # Build bundler version string
    #
    # @return [String]
    def bundler_version_string
      @bundler_version_string ||= "bundler_#{Bundler::VERSION.tr('.', '_')}"
    end
  end
end
