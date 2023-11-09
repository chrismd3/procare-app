# frozen_string_literal: true

%w[
  bundler
].each(&method(:require))

%w[
  version
  logger
  enabled
  latest_version
  errors
  build_bundler_definition
  commands
  configs/error_messages
  config
  configs/fetcher
  configs/validator
  handle_errors/messages
  handle_errors/build_exception_payload
  handle_errors/display_to_stdout
  handle_errors/report
  request_object
  request
  local_context/diffend
  local_context/host
  local_context/packages
  local_context/platform
  local_context
  request_verdict
  execute
  track
  shell
  repository
  integration_repository
].each { |file| require "diffend/#{file}" }

module Diffend
  module Plugin
    class << self
      # Registers the plugin and add before install all hook
      def register
        ::Bundler::Plugin.add_hook('before-install-all') do |_|
          execute
        end
      end

      # Execute diffend plugin
      def execute
        return unless Diffend::Enabled.call

        config = Diffend::Config.new(severity: Diffend::Logger::INFO)

        return unless config.execute?

        unless config.valid?
          config.print_errors

          exit 255
        end

        Diffend::LatestVersion.call(config)

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
end
