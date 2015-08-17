# Rcurl

Rcurl is a curl like(with limited number of features) tool with a pretty output.

It also provides simple way to send RPC requests in XML or JSON format.
 

## Installation

This is more like a standalone gem so adding it to Gemfile would not be that much beneficial.

Install it yourself as:

    $ gem install rcurl

## Usage

    rcurl URL [options] 

#### Available options

For available options use 

    rcurl --help

Command output

    Usage: rcurl URL [options]
        -X, --request=TYPE               Execute HTTP VERB
        -r, --rpc-xml x[,y,z]            Use RPC request. Provide comma separated list of arguments
        -u, --user=USER:PASSWORD         Basic auth user:password
        -d, --body BODY                  Provide body -d@file_path or json/xml body
        -H, --headers HEADERS            HTTP headers: -H 'Content-Type: value; X-Custom-Header: value'
        -h, --help                       Prints this help


##### Plain requests
    rcurl "http://host/api/v1/resource"

##### POST
 
    rcurl "http://host/api/v1/resource" -d@data.json -X POST

##### With bacis auth

    rcurl -u user:password "http://host/api/v1/resource"

##### XMLRPC
    rcurl "http://host/api_xmlrpc/v1/resource" --rpc MethodName,Param1,Param2,ParamX


### Example Response

Json api

```ruby
{
    "customer_id" => 1,
           "name" => Lucas,
        "address" => "Sunset avenue",
         "phone"  => "123-456-789"
}
```

#TODO:
* Better exceptions handling
* Implement SSL support
* Implement JSON RPC
* Implement  -i, -v, timeout flags
 


## Contributing

1. Fork it ( https://github.com/[my-github-username]/rcurl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
