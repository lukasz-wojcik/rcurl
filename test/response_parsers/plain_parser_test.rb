require 'test_helper'

require 'rcurl/response_parsers/plain_parser'
require 'oj'

describe Rcurl::ResponseParsers::PlainParser, "Plain parser" do
  let(:parser)  { Rcurl::ResponseParsers::PlainParser.new }

  describe "when content_type is application/json" do
    let(:response) do
      OpenStruct.new.tap do |o|
        o.body = "{\"some_key\": \"some_value\", \"other_key\": \"other_value\"}"
        o.content_type = 'application/json'
      end
    end

    it "parses json body" do
      result = parser.call(response)
      result.must_be_kind_of(Hash)
      result['some_key'].must_equal('some_value')
      result['other_key'].must_equal('other_value')
    end
  end


  describe "when content_type is application/xml" do
    let(:response) do
      OpenStruct.new.tap do |o|
        o.body = "<root><some_key>some_value</some_key><other_key>other_value</other_key></root>"
        o.content_type = 'application/xml'
      end
    end

    it "parses json body" do
      result = parser.call(response)
      result.must_be_kind_of(Hash)
      result['some_key'].must_equal('some_value')
      result['other_key'].must_equal('other_value')
    end
  end

  describe "when content_type is application/html" do
    let(:body) { "<html><p>Title</p><a href= \"http://www.wp.pl\"></a></html>" }
    let(:response) do
      OpenStruct.new.tap do |o|
        o.body = body
        o.content_type = 'application/html'
      end
    end

    it "returns body" do
      result = parser.call(response)
      result.must_be_kind_of(String)
      result.must_equal body
    end
  end


end
