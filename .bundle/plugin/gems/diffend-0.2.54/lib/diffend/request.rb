# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'json'

module Diffend
  # Module responsible for doing request to Diffend
  module Request
    # Message displayed when connection issue occured and we will retry
    CONNECTION_MESSAGE = 'We experienced a connection issue, retrying...'
    # List of connection exceptions
    CONNECTION_EXCEPTIONS = [
      Errno::ECONNRESET,
      Errno::ENETUNREACH,
      Errno::EHOSTUNREACH,
      Errno::ECONNREFUSED,
      SocketError
    ].freeze
    # Message displayed when timeout occured and we will retry
    TIMEOUT_MESSAGE = 'We experienced a connection issue, retrying...'
    # List of timeout exceptions
    TIMEOUT_EXCEPTIONS = [
      Net::OpenTimeout,
      Net::ReadTimeout
    ].freeze
    # Message displayed when server issue occured and we will retry
    SERVER_ERROR_MESSAGE = 'We experienced a server-side issue, retrying...'
    # List of server issues
    #
    # 500 - Internal Server Error
    # 502 - Bad Gateway
    # 503 - Service Unavailable
    # 504 - Gateway Timeout
    SERVER_ERRORS = [500, 502, 503, 504].freeze
    # Number of retries
    RETRIES = 3
    # Request headers
    HEADERS = { 'Content-Type': 'application/json' }.freeze

    private_constant :HEADERS

    class << self
      # Execute request
      #
      # @param request_object [Diffend::RequestObject]
      #
      # @return [Net::HTTPResponse] response from Diffend
      def call(request_object)
        retry_count ||= -1

        build_http(request_object.url) do |http, uri|
          response = http.request(
            build_request(
              uri,
              request_object.request_method,
              request_object.config,
              request_object.payload
            )
          )

          if SERVER_ERRORS.include?(response.code.to_i)
            raise Diffend::Errors::RequestServerError, response.code.to_i
          end

          response
        end
      rescue Diffend::Errors::RequestServerError => e
        retry_count += 1

        retry if handle_retry(request_object.config, SERVER_ERROR_MESSAGE, retry_count)

        Diffend::HandleErrors::Report.call(
          exception: e,
          payload: request_object.payload,
          config: request_object.config,
          message: :request_error
        )
      rescue *CONNECTION_EXCEPTIONS => e
        retry_count += 1

        retry if handle_retry(request_object.config, CONNECTION_MESSAGE, retry_count)

        Diffend::HandleErrors::Report.call(
          exception: e,
          payload: request_object.payload,
          config: request_object.config,
          message: :request_error
        )
      rescue *TIMEOUT_EXCEPTIONS => e
        retry_count += 1

        retry if handle_retry(request_object.config, TIMEOUT_MESSAGE, retry_count)

        Diffend::HandleErrors::Report.call(
          exception: e,
          payload: request_object.payload,
          config: request_object.config,
          message: :request_error
        )
      end

      # Handle retry
      #
      # @param config [Diffend::Config]
      # @param message [String] message we want to display
      # @param retry_count [Integer]
      def handle_retry(config, message, retry_count)
        return false if retry_count == RETRIES

        config.logger.warn(message)
        sleep(exponential_backoff(retry_count))

        retry_count < RETRIES
      end

      # Builds http connection object
      #
      # @param url [String] command endpoint url
      def build_http(url)
        uri = URI(url)

        Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: uri.scheme == 'https',
          open_timeout: 15,
          read_timeout: 15
        ) { |http| yield(http, uri) }
      end

      # Build http post request and assigns headers and payload
      #
      # @param uri [URI::HTTPS]
      # @param request_method [Symbol]
      # @param config [Diffend::Config]
      # @param payload [Hash] with versions to check
      #
      # @return [Net::HTTP::Post, Net::HTTP::Put]
      def build_request(uri, request_method, config, payload)
        pick_request_method(request_method)
          .new(uri.request_uri, HEADERS)
          .tap { |request| assign_auth(request, config) }
          .tap { |request| assign_payload(request, payload) }
      end

      # Pick request method
      #
      # @param request_method [Symbol]
      #
      # @return [Net::HTTP::Post, Net::HTTP::Put]
      def pick_request_method(request_method)
        case request_method
        when :post
          Net::HTTP::Post
        when :put
          Net::HTTP::Put
        end
      end

      # Assigns basic authorization if provided in the config
      #
      # @param request [Net::HTTP::Post] prepared http post
      # @param config [Diffend::Config]
      def assign_auth(request, config)
        return unless config.shareable_id
        return unless config.shareable_key

        request.basic_auth(config.shareable_id, config.shareable_key)
      end

      # Assigns payload as json
      #
      # @param request [Net::HTTP::Post] prepared http post
      # @param payload [Hash] with versions to check
      def assign_payload(request, payload)
        request.body = JSON.dump(payload: payload)
      end

      def exponential_backoff(retry_count)
        2**(retry_count + 1)
      end
    end
  end
end
