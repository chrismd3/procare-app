# frozen_string_literal: true

module Diffend
  # Module for all the components related to setting up the config
  module Configs
    # Class responsible for config error messages
    module ErrorMessages
      class << self
        # @return [String] malformed configuration file message
        def malformed_file
          'Your Diffend configuration file is malformed. Please re-setup.'
        end

        # Missing key message
        #
        # @param key [String] missing key
        #
        # @return [String]
        def missing_key(key)
          "Diffend configuration is missing #{key} key"
        end

        # Invalid key message
        #
        # @param config [Diffend::Config]
        # @param key [String] invalid key
        #
        # @return [String]
        def invalid_key(config, key)
          <<~MSG
            Diffend configuration value for #{key} is invalid.
            Expected #{Validator::KNOWN_KEYS[key].join(' or ')}, was #{config.public_send(key).class}.
          MSG
        end

        # Invalid uuid value message
        #
        # @param key [String] invalid key
        #
        # @return [String]
        def invalid_uuid(key)
          <<~MSG
            Diffend configuration value for #{key} is invalid.
          MSG
        end
      end
    end
  end
end
