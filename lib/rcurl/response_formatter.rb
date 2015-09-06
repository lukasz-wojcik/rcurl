# Formatters are executed in following order
# pre formatters in order of addition
# default formatter
# post formatters in order of addition
#
module Rcurl
  class ResponseFormatter

    attr_reader :response, :response_body, :options_object
    def initialize(response_body, response, options_object)
      @response_body = response_body
      @response = response
      @options_object = options_object
      @formatters = []
    end

    def add_formatter(formatter, type = :pre)
      @formatters << { formatter: formatter, type: type }
    end

    def call
      manage_formatters
      execute_pre_formatters
      execute_default_formatter
      execute_post_formatters
    end

    private

    def manage_formatters
      if @options_object.include_headers
        add_formatter(Rcurl::ResponseFormatters::IncludeHeaders.new, :pre)
      end
    end

    def execute_pre_formatters
      @formatters.select { |h| h[:type] == :pre }.each do |f|
        f[:formatter].render(response, response_body)
      end
    end

    def execute_post_formatters
      @formatters.select { |h| h[:type] == :post }.each do |f|
        f[:formatter].render(response, response_body)
      end

    end

    def execute_default_formatter
      Rcurl::ResponseFormatters::Default.new.render(response, response_body)
    end
  end
end
