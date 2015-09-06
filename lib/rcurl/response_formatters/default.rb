module Rcurl
  module ResponseFormatters
    class Default
      def render(response, response_body)
        ap response_body
      end
    end
  end
end
