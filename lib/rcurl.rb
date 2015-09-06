require "rcurl/version"

require "rcurl/http"
require "rcurl/exceptions_handler"
require "rcurl/request"
require "rcurl/factories/request_factory"

require "rcurl/requests/plain"
require "rcurl/requests/xml_rpc"
require "rcurl/response_parsers/xml_rpc_parser"
require "rcurl/response_parsers/plain_parser"

require "rcurl/response_formatters/default"
require "rcurl/response_formatters/include_headers"

require "rcurl/response_formatter"

require "rcurl/request_executor"

require "rcurl/ruby_option_parser"
require "rcurl/options_parser"


module Rcurl
  extend ExceptionsHandler

  def self.call(args)
    options = Rcurl::OptionsParser.new(argv: args).call

    uri = args[0]
    with_connection_exceptions_handling(uri) do
      Rcurl::RequestExecutor.new(uri, options).call
    end
  end
end
