require 'test_helper'

require "rcurl/response_formatters/default"
require "rcurl/response_formatters/include_headers"
require 'rcurl/response_formatter'

require 'awesome_print'

require 'stringio'

describe Rcurl::ResponseFormatter, "Response formatter test" do
  let(:options_object) { OpenStruct.new }
  let(:response_body) { "Body of the response" }
  let(:response) do
    OpenStruct.new.tap do |o|
      o.code = 200
      o.message = "OK"
      o.http_version = "1.1"
      o.header = {"content-type"=>["application/json; charset=utf-8"],
                  "x-request-id"=>["107cc6ef9a2f247436ae991462743c6c"],
                  "x-rack-cache"=>["miss"],
                  "connection"=>["close"],
                  "server"=>["thin"]}
    end
  end

  describe "when only default formatter is defined" do
    it "returns only body" do
      result = capture_stdout do
        Rcurl::ResponseFormatter.new(response_body, response, options_object).call
      end
      result.string.must_match response_body
    end
  end

  describe "when pre formatters present" do
    let(:pre_formatter) { Object.new.tap { |o| def o.render(*); puts "Pre formatter1" ;end} }
    let(:pre_formatter2) { Object.new.tap { |o| def o.render(*); puts "Pre formatter2" ;end} }
    let(:formatter) { Rcurl::ResponseFormatter.new(response_body, response, options_object) }

    before do
      formatter.add_formatter(pre_formatter, :pre)
      formatter.add_formatter(pre_formatter2, :pre)
    end

    it "executes preformatters before returning body" do
      result = capture_stdout do
        formatter.call
      end
      r1, r2, r3 = result.string.split("\n")
      r1.must_match "Pre formatter1"
      r2.must_match "Pre formatter2"
      r3.must_match response_body
    end
  end

  describe "when post formatters present" do
    let(:post_formatter) { Object.new.tap { |o| def o.render(*); puts "Post formatter1" ;end} }
    let(:post_formatter2) { Object.new.tap { |o| def o.render(*); puts "Post formatter2" ;end} }
    let(:formatter) { Rcurl::ResponseFormatter.new(response_body, response, options_object) }

    before do
      formatter.add_formatter(post_formatter, :post)
      formatter.add_formatter(post_formatter2, :post)
    end

    it "executes postformatters after returning body" do
      result = capture_stdout do
        formatter.call
      end
      r1, r2, r3 = result.string.split("\n")
      r1.must_match response_body
      r2.must_match "Post formatter1"
      r3.must_match "Post formatter2"
    end
  end

  describe "when post and pre formatters presnt" do
    let(:pre_formatter) { Object.new.tap { |o| def o.render(*); puts "Pre formatter1" ;end} }
    let(:post_formatter) { Object.new.tap { |o| def o.render(*); puts "Post formatter1" ;end} }
    let(:formatter) { Rcurl::ResponseFormatter.new(response_body, response, options_object) }

    before do
      formatter.add_formatter(post_formatter, :post)
      formatter.add_formatter(pre_formatter, :pre)
    end

    it "executes formatters in proper order" do
      result = capture_stdout do
        formatter.call
      end

      r1, r2, r3 = result.string.split("\n")
      r1.must_match "Pre formatter1"
      r2.must_match response_body
      r3.must_match "Post formatter1"
    end
  end

  describe "when include_headers opions is set" do
    let(:formatter) { Rcurl::ResponseFormatter.new(response_body, response, options_object) }

    before do
      options_object.include_headers = true
    end

    it "returns response headers before body" do
      result = capture_stdout do
        formatter.call
      end.string

      result.must_match "HTTP/1.1 200 OK"
      result.must_match "Content-Type: application/json; charset=utf-8"
      result.must_match "X-Request-Id: 107cc6ef9a2f247436ae991462743c6c"
      result.must_match "X-Rack-Cache: miss"
      result.must_match "Connection: close"
      result.must_match "Server: thin"
    end
  end
end
