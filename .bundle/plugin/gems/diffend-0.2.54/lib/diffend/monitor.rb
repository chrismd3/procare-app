# frozen_string_literal: true

%w[
  version
  logger
  errors
  build_bundler_definition
  commands
  configs/error_messages
  config
  configs/fetcher
  configs/validator
  handle_errors/messages
  handle_errors/build_exception_payload
  handle_errors/display_to_stdout
  handle_errors/report
  request_object
  request
  local_context/diffend
  local_context/host
  local_context/packages
  local_context/platform
  local_context
  request_verdict
  execute
  track
].each { |file| require "diffend/#{file}" }

# Calculate exponential backoff
#
# @param retry_count [Integer]
#
# @return [Float] backoff value
def exponential_backoff(retry_count)
  (0.25 * 1.5**retry_count.to_f).round(2)
end

Thread.new do
  config = nil
  retry_count = 0

  # There is an issue if we start to fast and there are gems that require things,
  # it may break the execution. That's why we want to give the application time to boot.
  sleep(0.5)

  loop do
    config = Diffend::Config.new(
      command: Diffend::Commands::EXEC,
      severity: Diffend::Logger::FATAL
    )

    break if config.valid?
    break if retry_count == 12

    sleep(exponential_backoff(retry_count))

    retry_count += 1
  end

  Thread.exit unless config.valid?
  Thread.exit unless config.deployment?

  track = Diffend::Track.new(config)
  track.start
end
