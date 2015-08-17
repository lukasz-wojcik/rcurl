require 'xmlsimple'

module Rcurl
  module ResponseParsers
    class PlainParser

      def initialize
      end

      def call(response)
        case response.content_type
        when /json/ then parse_json(response.body)
        when /xml/ then parse_xml(response.body)
        else
          response.body
        end
      end

      def parse_json(json)
        Oj.load(json)
      end

      def parse_xml(xml)
        XmlSimple.xml_in(xml, { 'ForceArray' => false })
      end

    end
  end
end
