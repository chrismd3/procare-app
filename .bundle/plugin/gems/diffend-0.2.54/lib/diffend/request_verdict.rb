# frozen_string_literal: true

require 'json'

module Diffend
  # Module responsible for fetching diffend verdict on local context
  module RequestVerdict
    # Exceptions that we handle when there is a resolve issue
    base_errors = [
      ::Bundler::GemNotFound,
      ::Bundler::GitError,
      ::Bundler::PermissionError
    ]

    # This error is not present in bundler newer than 2.4.0
    base_errors << ::Bundler::VersionConflict unless ::Bundler::VERSION >= '2.4.0'

    RESOLVE_EXCEPTIONS = base_errors.freeze

    class << self
      # @param config [Diffend::Config]
      # @param definition [::Bundler::Definition] definition for your source
      def call(config, definition)
        payload = Diffend::LocalContext.call(config, definition)

        response = Diffend::Request.call(
          build_request_object(config, payload)
        )

        JSON.parse(response.body)
      rescue *RESOLVE_EXCEPTIONS
        raise ::Diffend::Errors::DependenciesResolveException
      rescue StandardError => e
        Diffend::HandleErrors::Report.call(
          exception: e,
          payload: payload || {},
          config: config,
          message: :unhandled_exception,
          report: true
        )
      end

      # @param config [Diffend::Config]
      # @param payload [Hash]
      #
      # @return [Diffend::RequestObject]
      def build_request_object(config, payload)
        Diffend::RequestObject.new(
          config,
          config.commands_url,
          payload,
          :post
        )
      end
    end
  end
end
