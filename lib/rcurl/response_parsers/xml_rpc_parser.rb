module Rcurl
  module ResponseParsers
    class XmlRpcParser

      def initialize
        @parser = XMLRPC::XMLParser::REXMLStreamParser.new
      end

      def call(response)
        success, body = @parser.parseMethodResponse(response.body)
        if success
          body
        else
          body.to_h
        end
      end
    end
  end
end
