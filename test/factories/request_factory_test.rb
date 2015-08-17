require "test_helper"
require "rcurl/http"
require "rcurl/requests/plain"
require "rcurl/requests/xml_rpc"
require "rcurl/response_parsers/xml_rpc_parser"
require "rcurl/response_parsers/plain_parser"
require 'rcurl/factories/request_factory'
require 'uri'

describe Rcurl::Factories::RequestFactory do

  let(:uri) {URI("http://localhost:4567")}
  let(:options_object) { OpenStruct.new(verb: :get, body: "", headers: {}) }

  describe "#new" do
    let(:factory) { Rcurl::Factories::RequestFactory}
    describe "when no specific options are given" do
      it "returns plain request and parser" do
        request_object = factory.new(uri, options_object)
        request_object.must_respond_to :parser
        request_object.must_respond_to :request
        request_object.request.must_be_instance_of(Rcurl::Requests::Plain)
        request_object.parser.must_be_instance_of(Rcurl::ResponseParsers::PlainParser)
      end
    end

    describe "when xml_rpc option given" do
      before do
        options_object.xml_rpc = true
        options_object.rpc_params = ["methodName", "param"]
      end

      it "returns xml rpc" do
        request_object = factory.new(uri, options_object)
        request_object.must_respond_to :parser
        request_object.must_respond_to :request
        request_object.request.must_be_instance_of(Rcurl::Requests::XmlRpc)
        request_object.parser.must_be_instance_of(Rcurl::ResponseParsers::XmlRpcParser)
      end
    end

    describe "when json_rpc option given" do
      before do
        options_object.json_rpc = true
        options_object.json_params = ["methodName", "param"]
      end

      it "returns json rpc" do
        skip "Not implemented yet!"
        request_object = factory.new(uri, options_object)
        request_object.must_respond_to :parser
        request_object.must_respond_to :request
        request_object.request.must_be_instance_of(Rcurl::Requests::JsonRpc)
        request_object.parser.must_be_instance_of(Rcurl::ResponseParsers::JsonRpcParser)
      end
    end
  end
end
