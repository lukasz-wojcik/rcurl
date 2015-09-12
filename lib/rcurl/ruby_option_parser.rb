require 'optparse'
require 'ostruct'

class RubyOptionParser
  def self.parse(args)
    options = OpenStruct.new
    setup_defaults(options)

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: rcurl URL [options]"

      opts.on("-X TYPE", "--request=TYPE", [:GET, :POST, :PUT, :DELETE],
              "Execute HTTP VERB") do |t|
        options.verb = t.downcase
      end

      opts.on("-rxml","--rpc-xml x[,y,z]", "Use RPC request. Provide comma separated list of arguments") do |v|
        params = v.split(",").map(&:strip)
        options.xml_rpc = true
        options.rpc_params = params

      end

      opts.on("-u USER:PASSWORD", "--user=USER:PASSWORD", "Basic auth user:password") do |v|
        basic_auth = get_basic_auth(v)
        options.basic_auth = basic_auth
      end

      opts.on("-d@FILE","--body BODY", "Provide body -d@file_path or json/xml body") do |b|
        body = get_body(b)
        options.body = body
      end

      opts.on("-i","--include", "Include HTTP headers") do |b|
        options.include_headers = true
      end

      opts.on("-k","--insecure", "Option allows to execute insecure SSL connections") do |b|
        options.insecure = true
      end

      opts.on("--cert PATH", "Use specified certificate file") do |cert_path|
        options.cert  = File.read(cert_path)
      end

      opts.on("--cacert PATH", "Use specified certificate(CA cert) file for peer verification") do |ca_path|
        options.cacert = File.read(ca_path)
        options.ca_path = ca_path
      end

      opts.on("--key PATH", "Use private key filename") do |key|
        options.certkey = File.read(key)
      end

      opts.on("-H HEADERS", "--headers HEADERS",
              "HTTP headers: -H 'Content-Type: value; X-Custom-Header: value' ") do |v|
        header_strings = v.split(";")
        parsed_headers  = header_strings.inject({}) do |headers, str|
          name, value = str.split(":", 2)
          headers[name] = value.strip; headers
        end
        options.headers.merge!(parsed_headers)
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    return options
  rescue OptionParser::InvalidOption => e
    puts e.message
    puts "Usage: rcurl URL [options]"
    puts opt_parser.summarize
    exit
  end

  def self.get_body(body)
    return body unless body[0] == "@"
    filename = body[1..-1]
    if File.exists?(filename)
      File.read(filename)
    else
      raise "Invalid filename"
    end
  end

  def self.get_basic_auth(value)
    return nil unless value.match(":")
    value.split(":", 2)
  end


  def self.setup_defaults(options)
    options.verb = :get
    options.headers = {}
    options.body = nil
  end

  def self.set_verb(verb)
    {
      "POST" => :post,
      "GET" => :get,
      "PUT" => :put,
      "DELETE" => :delete,
    }.fetch(verb)
  end
end
