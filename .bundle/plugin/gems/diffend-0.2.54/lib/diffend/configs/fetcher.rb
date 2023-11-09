# frozen_string_literal: true

%w[
  erb
  yaml
].each(&method(:require))

module Diffend
  # Module for all the components related to setting up the config
  module Configs
    # Class responsible for fetching the config from .diffend.yml
    module Fetcher
      class << self
        # @param plugin_path [String] path of the plugin
        # @param build_path [String] path of the current build
        #
        # @return [Hash] details from configuration file
        #
        # @example
        #   details = Fetcher.new.call('./')
        #   details.build_path #=> './'
        def call(plugin_path, build_path)
          default_config = File.join(plugin_path, 'config', 'diffend.yml')
          project_config = File.join(build_path, Diffend::Config::FILENAME)

          hash = read_file(default_config)

          if File.exist?(project_config)
            hash.merge!(read_file(project_config) || {})
          end

          hash
        end

        private

        # Load config file
        #
        # @param file_path [String]
        #
        # @return [Hash]
        def read_file(file_path)
          YAML.safe_load(ERB.new(File.read(file_path)).result)
        rescue Psych::SyntaxError
          raise Errors::MalformedConfigurationFile
        end
      end
    end
  end
end
