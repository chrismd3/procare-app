# frozen_string_literal: true

module Diffend
  # Build runner app errors
  module Errors
    # Base error class from which all the errors should inherit
    BaseError = Class.new(StandardError)
    # Raised when configuration file is malformed
    MalformedConfigurationFile = Class.new(BaseError)
    # Raised when project_id is missing in configuration file
    ProjectIdMissingInConfigurationFile = Class.new(BaseError)
    # Raised when shareable_id is missing in configuration file
    ShareableIdMissingInConfigurationFile = Class.new(BaseError)
    # Raised when shareable_key is missing in configuration file
    ShareableKeyMissingInConfigurationFile = Class.new(BaseError)
    # Raised when build_path is missing in configuration file
    BuildPathMissingInConfigurationFile = Class.new(BaseError)
    # Raised when server-side error occurs
    RequestServerError = Class.new(BaseError)
    # Raised when we had an exception that we know how to handle
    HandledException = Class.new(BaseError)
    # Raised when we are unable to resolve dependencies
    DependenciesResolveException = Class.new(BaseError)
    # Failure of a shell command execution
    FailedShellCommand = Class.new(BaseError)
  end
end
