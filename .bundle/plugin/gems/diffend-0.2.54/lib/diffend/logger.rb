# frozen_string_literal: true

module Diffend
  # Diffend logging
  class Logger
    # Low-level information, mostly for developers
    DEBUG = 0
    # Generic (useful) information about system operation
    INFO = 1
    # A warning
    WARN = 2
    # A handleable error condition
    ERROR = 3
    # An error that we are unable to handle that results in a program crash
    FATAL = 4
    # An unknown message that should always be logged
    UNKNOWN = 5

    # @param level [Integer] logging severity threshold
    def initialize(level = INFO)
      @level = level
    end

    # @param message [String]
    def debug(message)
      log(DEBUG, message)
    end

    # @param message [String]
    def info(message)
      log(INFO, message)
    end

    # @param message [String]
    def warn(message)
      log(WARN, message)
    end

    # @param message [String]
    def error(message)
      log(ERROR, message)
    end

    # @param message [String]
    def fatal(message)
      log(FATAL, message)
    end

    private

    # @param severity [Integer]
    # @param message [String]
    def log(severity, message)
      return if severity < @level

      case severity
      when INFO
        ::Bundler.ui.confirm(message)
      when WARN
        ::Bundler.ui.warn(message)
      when ERROR, FATAL
        ::Bundler.ui.error(message)
      end
    end
  end
end
