require 'test_helper'
require 'rcurl/http'
require 'ostruct'
require 'uri'

describe Rcurl::Http, "Http module test" do

  let(:http) { Object.new.extend(Rcurl::Http) }
  let(:request)  { OpenStruct.new }

  it "#set_headers" do
    headers = {"Content-Type" => "application/xml", "X-Custom-Header" => "test"}
    http.set_headers!(request, headers)
    assert_equal(request["Content-Type"], "application/xml")
    assert_equal(request["X-Custom-Header"], "test")
  end

  describe "#parse_uri" do

    describe "when uri is valid" do
      it "is instance of URI::HTTP" do
        uri = http.parse_uri("http://localhost:4567")
        uri.must_be_kind_of(URI::HTTP)
      end
    end

    describe "when uri is nil" do
      it "raises ArgumentError" do
        proc { http.parse_uri(nil) }.must_raise(ArgumentError, "missing keyword: uri")
      end
    end

  end

  describe "#create_request" do

    let(:uri) { URI("http://localhost:4567") }
    let(:body) { "<xml><tag>TEST</tag></xml>" }

    it "get" do
      http.create_request(uri, :get, body).must_be_kind_of(Net::HTTP::Get)
    end

    it "post" do
      http.create_request(uri, :post, body).must_be_kind_of(Net::HTTP::Post)
    end

    it "put" do
      http.create_request(uri, :put, body).must_be_kind_of(Net::HTTP::Put)
    end

    it "delete" do
      http.create_request(uri, :delete, body).must_be_kind_of(Net::HTTP::Delete)
    end

    it "unknown" do
      unknown = proc { http.create_request(uri, :unknown, body) }
      unknown.must_raise(RuntimeError, "Unknown/Unimplemented HTTP request verb")
    end
  end
end
