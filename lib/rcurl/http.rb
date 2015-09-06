require "net/http"
module Rcurl
  module Http

    def send_request(uri, http_verb, body, headers, options)
      uri = parse_uri(uri)
      request = create_request(uri, http_verb, body)
      apply_basic_auth!(request, options) if options.basic_auth
      set_headers!(request, headers)
      set_ssl!(request, options)
      perform_http_request(request, uri)
    end

    def post(uri, body)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = body
      request
    end

    def put(uri, body)
      request = Net::HTTP::Put.new(uri.request_uri)
      request.body = body
      request
    end

    def get(uri)
      Net::HTTP::Get.new(uri.request_uri)
    end

    def delete(uri)
      Net::HTTP::Delete.new(uri.request_uri)
    end

    def apply_basic_auth!(request, options)
      request.basic_auth(*options.basic_auth)
    end

    def set_headers!(request, headers = {})
      headers.each do |header, value|
        request[header] = value
      end
    end

    def parse_uri(uri)
      validate_uri!(uri)
      uri = process_uri(uri)
      URI(uri)
    end

    def set_ssl!(request, options)
      #TODO: implement!!!
      return
    end

    def create_request(uri, http_verb, body)
      case http_verb
      when :get then get(uri)
      when :post then post(uri, body)
      when :put then put(uri, body)
      when :delete then delete(uri)
      else
        raise "Unknown/Unimplemented HTTP request verb"
      end
    end

    def perform_http_request(request, uri)
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(request)
      end
    end

    def validate_uri!(uri)
      if uri.nil?
        raise ArgumentError, "missing keyword: uri"
      end
    end

    def process_uri(uri)
      uri.match(/https|http/) ? uri : "http://#{uri}"
    end
  end
end
