require 'xmlrpc/server'

module Rcurl
  module Requests
    class XmlRpc
      include Http

      attr_accessor :http_verb, :uri, :body, :headers, :options

      def initialize(uri: nil, http_verb: :get, body: '', headers: {}, options: {})
        @http_verb = http_verb
        @uri = uri
        @headers = headers
        @options = options
        @body = prepare_xmlrpc_body
      end

      def call
        send_request(uri, http_verb, body, headers, options)
      end

      def prepare_xmlrpc_body
        XMLRPC::Create.new.methodCall(*@options.rpc_params)
      end
    end
  end
end

