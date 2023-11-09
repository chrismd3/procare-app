# frozen_string_literal: true

module Diffend
  # Verify if the plugin is enabled
  module Enabled
    class << self
      # Checks if plugin is enabled
      #
      # @return [Boolean] true if enabled, false otherwise
      def call
        ::Bundler
          .default_gemfile
          .read
          .split("\n")
          .reject(&:empty?)
          .map(&:strip)
          .select { |line| line.start_with?('plugin') }
          .any? { |line| line.include?('diffend') }
      end
    end
  end
end
