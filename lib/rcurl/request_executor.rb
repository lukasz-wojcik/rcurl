module Rcurl
  class RequestExecutor
    attr_accessor :uri, :options_object

    def initialize(uri, options_object)
      @uri = uri
      @options_object = options_object
    end

    def call
      request_object = Rcurl::Factories::RequestFactory.new(uri, options_object)
      response = Rcurl::Request.new(request_object.request).call
      request_object.parser.call(response)
    end
  end
end
