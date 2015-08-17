module Rcurl
  class Request
    def initialize(request_type)
      @request_type  = request_type
    end

    def call
      @request_type.call
    end
  end
end
