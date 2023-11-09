# frozen_string_literal: true

module Diffend
  # Module responsible for building local context
  module LocalContext
    class << self
      # Build diffend, host, packages, and platform specific information
      #
      # @param config [Diffend::Config]
      # @param definition [::Bundler::Definition] definition for your source
      #
      # @return [Hash] payload for diffend endpoint
      def call(config, definition)
        {
          'diffend' => Diffend.call(config),
          'host' => Host.call,
          'packages' => Packages.call(config.command, definition),
          'platform' => Platform.call
        }.freeze
      end
    end
  end
end
