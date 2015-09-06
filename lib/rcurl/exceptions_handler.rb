module Rcurl
  module ExceptionsHandler
    def with_connection_exceptions_handling(uri)
      begin
        yield
      rescue SocketError
        ap "Could not resolve hostname #{uri}"
      rescue  StandardError => e
        ap e.message
      end
    end
  end
end
