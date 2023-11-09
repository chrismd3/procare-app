# frozen_string_literal: true

module Diffend
  # Extend bundler with a new secure command to be able to run Diffend separately
  class BundleSecure
    ::Bundler::Plugin::API.command(Diffend::Commands::SECURE, self)

    # Execute diffend check
    #
    # @param _name [String] command name
    # @param _args [Array] arguments from ARGV
    def exec(_name, _args)
      config = Diffend::Config.new(
        command: Diffend::Commands::SECURE,
        severity: Diffend::Logger::INFO
      )

      Diffend::LatestVersion.call(config)

      return unless config.execute?

      unless config.valid?
        config.print_errors

        exit 255
      end

      Diffend::Execute.call(config)
    rescue Diffend::Errors::HandledException
      # config will not be initialized when configuration file is missing
      return if config&.ignore_errors?

      exit 255
    rescue StandardError => e
      Diffend::HandleErrors::Report.call(
        exception: e,
        config: config,
        message: :unhandled_exception,
        report: true,
        raise_exception: false
      )

      return if config.ignore_errors?

      exit 255
    end
  end
end
