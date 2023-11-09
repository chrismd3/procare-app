# frozen_string_literal: true

module Diffend
  # Class responsible for preparing diffend request object
  RequestObject = Struct.new(:config, :url, :payload, :request_method)
end
