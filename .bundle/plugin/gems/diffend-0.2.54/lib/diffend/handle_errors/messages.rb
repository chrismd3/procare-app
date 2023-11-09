# frozen_string_literal: true

module Diffend
  module HandleErrors
    module Messages
      PAYLOAD_DUMP = '^^^ Above is the dump of your request ^^^'
      UNHANDLED_EXCEPTION = <<~MSG
        \nSomething went really wrong. We recorded this incident in our system and will review it.\n
        This is a bug, don't hesitate.\n
        Create an issue at https://github.com/diffend-io/diffend-ruby/issues\n
      MSG
      UNSUPPORTED_RESPONSE = <<~MSG
        \nAPI returned an unsupported response. We recorded this incident in our system and will review it.\n
        This is a bug, don't hesitate.\n
        Create an issue at https://github.com/diffend-io/diffend-ruby/issues\n
      MSG
      UNSUPPORTED_VERDICT = <<~MSG
        \nAPI returned an unsupported verdict. We recorded this incident in our system and will review it.\n
        This is a bug, don't hesitate.\n
        Create an issue at https://github.com/diffend-io/diffend-ruby/issues\n
      MSG
      REQUEST_ERROR = <<~MSG
        \nWe were unable to process your request at this time. We recorded this incident in our system and will review it.\n
        If you think that this is a bug, don't hesitate.\n
        Create an issue at https://github.com/diffend-io/diffend-ruby/issues\n
      MSG
    end
  end
end
