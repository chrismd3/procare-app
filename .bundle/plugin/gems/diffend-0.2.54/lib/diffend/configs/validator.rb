# frozen_string_literal: true

module Diffend
  # Module for all the components related to setting up the config
  module Configs
    # Class responsible for validating the config from .diffend.yml
    module Validator
      # List of known config keys
      KNOWN_KEYS = {
        project_id: [String],
        shareable_id: [String],
        shareable_key: [String],
        build_path: [String],
        env: [String],
        command: [String],
        ignore_errors?: [TrueClass, FalseClass],
        development?: [TrueClass, FalseClass]
      }.freeze

      # List of known uuid keys
      UUID_KEYS = %i[project_id shareable_id shareable_key].freeze

      # Imported from https://github.com/assaf/uuid/blob/master/lib/uuid.rb#L199
      UUID_FORMAT = /\A[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i

      private_constant :UUID_KEYS, :UUID_FORMAT

      class << self
        # @param config [Diffend::Config]
        def call(config)
          KNOWN_KEYS.each_key do |key|
            if missing?(config, key)
              config.errors << ErrorMessages.missing_key(key)
              next
            end

            config.errors << ErrorMessages.invalid_key(config, key) if invalid?(config, key)
          end

          UUID_KEYS.each do |key|
            next if valid_uuid?(config, key)

            config.errors << ErrorMessages.invalid_uuid(key)
          end
        end

        private

        # @param config [Diffend::Config]
        # @param key [String]
        #
        # @return [Boolean] true if we are missing a key, false otherwise
        def missing?(config, key)
          value = config.public_send(key)

          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end

        # @param config [Diffend::Config]
        # @param key [String]
        #
        # @return [Boolean] true if we are missing a key, false otherwise
        def invalid?(config, key)
          !KNOWN_KEYS[key].include?(config.public_send(key).class)
        end

        # @param config [Diffend::Config]
        # @param key [String]
        #
        # @return [Boolean] true if key has a valid uuid, false otherwise
        def valid_uuid?(config, key)
          UUID_FORMAT.match?(config.public_send(key))
        end
      end
    end
  end
end
