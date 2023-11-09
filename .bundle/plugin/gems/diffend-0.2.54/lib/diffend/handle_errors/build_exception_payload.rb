# frozen_string_literal: true

require 'securerandom'

module Diffend
  # Errors handlers namespace
  module HandleErrors
    # Module responsible for building exception payload
    module BuildExceptionPayload
      class << self
        # Build exception payload
        #
        # @param exception [Exception, NilClass] expection that was raised
        # @param payload [Hash] with versions to check
        #
        # @return [Hash]
        def call(exception, payload)
          {
            request_id: SecureRandom.uuid,
            payload: payload,
            exception: {
              class: exception&.class,
              message: exception&.message,
              backtrace: exception&.backtrace
            }
          }.freeze
        end
      end
    end
  end
end
