# frozen_string_literal: true

module Diffend
  module HandleErrors
    # Module responsible for reporting errors to diffend
    module Report
      class << self
        # Execute request to Diffend
        #
        # @param config [Diffend::Config]
        # @param message [Symbol] message that we want to display
        # @param exception [Exception] expection that was raised
        # @param payload [Hash] with versions to check
        # @param report [Boolean] if true we will report the issue to diffend
        # @param raise_exception [Boolean] if true we will raise an exception
        #
        # @return [Net::HTTPResponse] response from Diffend
        def call(config:, message:, exception: nil, payload: {}, report: false, raise_exception: true)
          exception_payload = prepare_exception_payload(exception, payload)

          Diffend::HandleErrors::Messages::PAYLOAD_DUMP
            .tap(&config.logger.method(:error))
          Diffend::HandleErrors::Messages
            .const_get(message.to_s.upcase)
            .tap(&config.logger.method(:error))

          if report
            Diffend::Request.call(
              build_request_object(config, exception_payload)
            )
          end

          raise Diffend::Errors::HandledException if raise_exception
        end

        # @param config [Diffend::Config]
        # @param payload [Hash]
        #
        # @return [Diffend::RequestObject]
        def build_request_object(config, payload)
          Diffend::RequestObject.new(
            config,
            config.errors_url,
            payload,
            :post
          )
        end

        # Prepare exception payload and display it to stdout
        #
        # @param exception [Exception] expection that was raised
        # @param payload [Hash] with versions to check
        #
        # @return [Hash]
        def prepare_exception_payload(exception, payload)
          Diffend::HandleErrors::BuildExceptionPayload
            .call(exception, payload)
            .tap(&Diffend::HandleErrors::DisplayToStdout.method(:call))
        end
      end
    end
  end
end
