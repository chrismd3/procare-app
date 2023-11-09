# frozen_string_literal: true

module Diffend
  # Track what is run in production
  class Track
    # Time that we want to wait between track requests
    TRACK_SLEEP = 15
    # Time that we want to wait before we retry
    RETRY_SLEEP = 15

    # Initialize tracking
    #
    # @param config [Diffend::Config]
    def initialize(config)
      @mutex = Mutex.new
      @config = config
    end

    # Start tracking
    def start
      response = Diffend::Execute.call(@config)

      perform(response['id'])
    rescue Diffend::Errors::HandledException
      sleep(RETRY_SLEEP)

      retry
    rescue StandardError => e
      Diffend::HandleErrors::Report.call(
        exception: e,
        config: @config,
        message: :unhandled_exception,
        report: true,
        raise_exception: false
      )

      sleep(RETRY_SLEEP)

      retry
    end

    # @param request_id [String]
    def perform(request_id)
      loop do
        @mutex.synchronize { track_request(request_id) }

        sleep(TRACK_SLEEP)
      end
    end

    # Perform a track request
    #
    # @param request_id [String]
    def track_request(request_id)
      Diffend::Request.call(
        build_request_object(request_id)
      )
    end

    # @param request_id [String]
    #
    # @return [Diffend::RequestObject]
    def build_request_object(request_id)
      Diffend::RequestObject.new(
        @config,
        @config.track_url(request_id),
        { id: request_id }.freeze,
        :put
      ).freeze
    end
  end
end
