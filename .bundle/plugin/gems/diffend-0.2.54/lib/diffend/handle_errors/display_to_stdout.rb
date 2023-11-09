# frozen_string_literal: true

module Diffend
  module HandleErrors
    # Module responsible for displaying exception payload to stdout
    module DisplayToStdout
      class << self
        # Display exception payload to stdout
        #
        # @param exception_payload [Hash]
        def call(exception_payload)
          puts exception_payload.to_json
        end
      end
    end
  end
end
