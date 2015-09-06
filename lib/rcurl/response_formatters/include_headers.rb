module Rcurl
  module ResponseFormatters
    class IncludeHeaders

      def render(response, response_body)
        puts %Q{#{http_version(response)}
#{get_headers(response)}
        }.strip
      end

      private

      def http_version(response)
        "HTTP/#{response.http_version} #{response.code} #{response.message}"
      end

      def get_headers(response)
        headers_hash = response.header.to_hash
        headers_hash.map do |header, value|
          "#{header.split("-").map!(&:capitalize).join("-")}: #{value.join}"
        end.join("\n")
      end

    end
  end
end

