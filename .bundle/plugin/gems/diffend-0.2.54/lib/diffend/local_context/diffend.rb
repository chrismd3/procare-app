# frozen_string_literal: true

module Diffend
  # Module responsible for building local context
  module LocalContext
    # Module responsible for building diffend information from local context
    module Diffend
      # API version
      API_VERSION = '0.1'
      # Platform type ruby
      PLATFORM_TYPE = 0

      private_constant :API_VERSION, :PLATFORM_TYPE

      class << self
        # Build diffend information
        #
        # @param config [Diffend::Config]
        #
        # @return [Hash]
        def call(config)
          {
            'api_version' => API_VERSION,
            'environment' => config.env,
            'project_id' => config.project_id,
            'type' => PLATFORM_TYPE,
            'version' => ::Diffend::VERSION
          }.freeze
        end
      end
    end
  end
end
