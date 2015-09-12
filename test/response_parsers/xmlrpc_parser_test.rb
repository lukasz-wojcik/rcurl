require 'test_helper'


describe Rcurl::ResponseParsers::XmlRpcParser, "XmlRpc parser" do

  let(:parser)  { Rcurl::ResponseParsers::XmlRpcParser.new }

  describe "#call" do
    let(:success_response) do
      OpenStruct.new.tap do |r|
        r.body = %Q(
          <?xml version="1.0"?>
          <methodResponse>
             <params>
                <param>
                   <value><string>Some string</string></value>
                </param>
             </params>
          </methodResponse>
        )
      end
    end

    let(:fault_response_hash) do
      OpenStruct.new.tap  do |r|
        r.body = %Q(
        <?xml version="1.0" encoding="UTF-8"?>
        <methodResponse>
          <fault>
            <value>
              <struct>
                <member>
                  <name>faultCode</name>
                  <value>
                    <i4>31</i4>
                  </value>
                </member>
                <member>
                  <name>faultString</name>
                  <value>
                    <string>Error message</string>
                  </value>
                </member>
              </struct>
            </value>
          </fault>
        </methodResponse>
        )
      end
    end

    let(:fault_response) do
      OpenStruct.new.tap  do |r|
        r.body = %Q(
        <?xml version="1.0" encoding="UTF-8"?>
        <methodResponse>
           <fault>
              <value><string>No such method!</string></value>
           </fault>
        </methodResponse>
        )
      end
    end

    it "should retun success response" do
      result = parser.call(success_response)
      result.must_equal("Some string")
    end

    it "should return error response hash" do
      result = parser.call(fault_response_hash)
      result.must_be_kind_of(Hash)
      result["faultCode"].must_equal 31
      result["faultString"].must_equal "Error message"
    end

    it "should raise excetpion for wrong fault response format" do
      proc { parser.call(fault_response) }.must_raise(RuntimeError, "wrong fault-structure: \"No such method!\"")
    end
  end
end
