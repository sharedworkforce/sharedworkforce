require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HitRequest" do
  
  it "should invoke a hit request" do
    
    hit = Hci::Hit.define("Approve photo") {}
    hit_request = Hci::HitRequest.new(hit, 1234)
    
    stub_request(:post, "hci.heroku.com/hits")
    hit_request.invoke
    a_request(:post, "http://hci.heroku.com/hits").with(:body=>{'name'=>"Approve photo", 'resource_id'=>'1234', :api_key=>'test-api-key'}).should have_been_made.once
    
  end
  
end


