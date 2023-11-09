# frozen_string_literal: true

module Diffend
  # Verify if we are running latest version of the plugin
  module LatestVersion
    class << self
      # Verify if we are running latest version of the plugin
      #
      # @param config [Diffend::Config]
      def call(config)
        return if config.development?
        return if installed_version == Diffend::VERSION

        print_message(config, installed_version)

        exit 2
      end

      private

      # @return [String] installed plugin version
      def installed_version
        ::Bundler::Plugin
          .index
          .plugin_path('diffend')
          .basename
          .to_s
          .split('-')
          .last
      end

      # @param config [Diffend::Config]
      # @param version [Hash] installed version
      def print_message(config, version)
        build_message(version)
          .tap(&config.logger.method(:error))
      end

      # @param version [Hash] installed version
      #
      # @return [String]
      def build_message(version)
        <<~MSG
          \nYou are running an outdated version (#{version}) of the plugin, which will lead to issues.
          \nPlease upgrade to the latest one (#{Diffend::VERSION}) by executing "rm -rf .bundle/plugin".\n
        MSG
      end
    end
  end
end
