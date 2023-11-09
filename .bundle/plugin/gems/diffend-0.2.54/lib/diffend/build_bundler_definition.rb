# frozen_string_literal: true

module Diffend
  # Builds bundler definition used within the plugin
  module BuildBundlerDefinition
    class << self
      # Build clean instance of bundler definition, as we don't want to pollute the main one
      #
      # @param command [String] command executed via bundler
      # @param gemfile [String] path to Gemfile
      # @param lockfile [String] path to Gemfile.lock
      #
      # @return [::Bundler::Definition]
      def call(command, gemfile, lockfile)
        unlock = command == 'update' ? true : nil

        ::Bundler.configure
        ::Bundler::Fetcher.disable_endpoint = nil

        ::Bundler::Definition
          .build(gemfile, lockfile, unlock)
          .tap(&:validate_runtime!)
      end
    end
  end
end
