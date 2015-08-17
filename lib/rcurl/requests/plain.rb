module Rcurl
  module Requests
    class Plain
      include Http
      attr_accessor :http_verb, :uri, :body, :headers, :options

      def initialize(uri: nil, http_verb: :get, body: '', headers: {}, options: {})
        @http_verb = http_verb
        @uri = uri
        @body = body
        @headers = headers
        @options = options
      end

      def call
        send_request(uri, http_verb, body, headers, options)
      end
    end
  end
end












