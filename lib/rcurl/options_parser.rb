module Rcurl
  class OptionsParser
    attr_reader :argv, :parser

    def initialize(argv: [], parser: RubyOptionParser)
      @parser = parser
      @argv = argv
    end

    def call
      parser.parse(argv)
    end
  end
end
