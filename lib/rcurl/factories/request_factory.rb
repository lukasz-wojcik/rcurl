require 'xmlrpc/server'

module Rcurl
  module Factories
    class RequestFactory

      attr_reader :request, :parser

      def initialize(uri, options_object)
        @uri, @options_object = uri, options_object

        @request, @parser = if @options_object.xml_rpc
                              initialize_xml_rpc
                            elsif @options_object.json_rpc
                              initialize_json_rpc
                            else
                              initialize_plain
                            end
      end

      private

      def initialize_request(request_class)
        verb, body, headers, options = get_params
        request_class.new(uri: @uri,
                          http_verb: verb,
                          body: body,
                          headers: headers,
                          options: options)
      end

      def initialize_response_parser(parser_class)
        parser_class.new
      end

      def initialize_plain
        [ initialize_request(Rcurl::Requests::Plain),
          initialize_response_parser(Rcurl::ResponseParsers::PlainParser) ]
      end

      def initialize_xml_rpc
        [ initialize_request(Rcurl::Requests::XmlRpc),
          initialize_response_parser(Rcurl::ResponseParsers::XmlRpcParser) ]
      end

      def initialize_json_rpc
        [ initialize_request(Rcurl::Requests::JsonRpc),
          initialize_response_parser(Rcurl::ResponseParsers::JsonRpcParser) ]
      end

      def get_params
        [
          @options_object.verb,
          @options_object.body,
          @options_object.headers,
          @options_object,
        ]
      end

    end
  end
end
