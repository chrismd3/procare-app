# frozen_string_literal: true

module Diffend
  # Diffend config object
  class Config
    # Name of the diffend config file
    FILENAME = '.diffend.yml'

    attr_reader :project_id, :shareable_id, :shareable_key, :build_path, :env, :command, :errors

    # Build diffend config object
    #
    # @param command [String] command executed via bundler
    # @param severity [Integer] logging severity threshold
    # @param build_path [String] path of the current build
    #
    # @return [Diffend::Config]
    def initialize(command: nil, severity: nil, build_path: nil)
      @log_level = severity
      @errors = []
      build(command, build_path)
      Diffend::Configs::Validator.call(self)
    end

    # Initialize logger
    def logger
      @logger ||= Diffend::Logger.new(@log_level)
    end

    # @return [Boolean] true if config is valid, false otherwise
    def valid?
      @errors.empty?
    end

    # @return [Boolean] true if we want to ignore errors, false otherwise
    def ignore_errors?
      @ignore_errors
    end

    # @return [Boolean] true if we are in development mode, false otherwise
    def development?
      @development
    end

    # This method is provided just in case something would go wrong with Diffend but there would be
    # a need to run Bundler anyhow. Please don't use unless aware of the downsides.
    #
    # @return [Boolean] should we run Diffend or skip it and continue without it.
    def execute?
      @execute
    end

    # @return [Boolean] true if we are in deployment mode, false otherwise
    def deployment?
      !%w[development test].include?(env)
    end

    # Provides diffend commands endpoint url
    #
    # @return [String]
    def commands_url
      return ENV['DIFFEND_COMMANDS_URL'] if ENV.key?('DIFFEND_COMMANDS_URL')

      "https://my.diffend.io/api/projects/#{project_id}/bundle/#{command}"
    end

    # Provides diffend errors endpoint url
    #
    # @return [String]
    def errors_url
      return ENV['DIFFEND_ERRORS_URL'] if ENV.key?('DIFFEND_ERRORS_URL')

      "https://my.diffend.io/api/projects/#{project_id}/errors"
    end

    # @param request_id [String]
    #
    # @return [String]
    def track_url(request_id)
      "https://my.diffend.io/api/projects/#{project_id}/bundle/#{request_id}/track"
    end

    # Print config errors
    def print_errors
      @errors.each { |error| logger.fatal(error) }
    end

    private

    # @param command [String] command executed via bundler
    # @param build_path [String] path of the current build
    def build(command, build_path)
      build_path ||= File.expand_path('..', ::Bundler.bin_path)
      hash = Diffend::Configs::Fetcher.call(plugin_path, build_path)
      hash['build_path'] = build_path
      hash['command'] = command || build_command

      hash.each { |key, value| instance_variable_set(:"@#{key}", value) }
    rescue Errors::MalformedConfigurationFile
      @errors << Diffend::Configs::ErrorMessages.malformed_file
    end

    # Command that was run with bundle
    #
    # @return [String]
    def build_command
      default = ::Bundler.feature_flag.default_cli_command.to_s

      return default unless ARGV.first
      # There is a case where no command may be provided and the first argument is the first option
      # In a case like this we fallback to default command
      return default if ARGV.first.start_with?('-')

      ARGV.first
    end

    # @return [String] path to the plugin
    def plugin_path
      Pathname.new(File.expand_path('../..', __dir__))
    end
  end
end
