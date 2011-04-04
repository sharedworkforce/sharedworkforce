require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Hit" do
  it "should define a hit" do
    
    SharedWorkforce::Hit.define "Approve photo" do |h|
      
      h.directions = "Please classify this photo by choosing the appropriate tickboxes."
      h.image_url = "http://www.google.com/logo.png"
      h.answer_options = ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children']
      h.responses_required = 3

      h.on_completion do |result|
        puts "Complete"
      end

      h.on_failure do |result|
        puts "Failed"
      end

    end
    
    SharedWorkforce::Hit.hits.first[1].directions.should == "Please classify this photo by choosing the appropriate tickboxes."
    
  end
  
  it "should run a completion callback" do
    
    object = OpenStruct.new(:test=>nil)
    
    hit = SharedWorkforce::Hit.define "Approve photo" do |h|
      
      h.on_completion do |result|
        object.test = "Complete"
      end
      
    end
    
    object.test.should == nil
    hit.complete!({})
    object.test.should == "Complete"
  end
  
  it "should run a failure callback" do
    
    object = OpenStruct.new(:test=>nil)
    
    hit = SharedWorkforce::Hit.define "Approve photo" do |h|
      
      h.on_failure do |result|
        object.test = "Failed"
      end
      
    end
    
    object.test.should == nil
    hit.fail!({})
    object.test.should == "Failed"
  end
  
  it "should not raise an error if there is no callback defined" do
    lambda {
      hit = SharedWorkforce::Hit.define("Approve photo") { }
      hit.fail!({})
    }.should_not raise_error
  end
  
  it "should request a hit" do
    hit = SharedWorkforce::Hit.define("Approve photo") { }
    hit.should_receive(:request).with(:request_id=>'123')
    SharedWorkforce::Hit.request("Approve photo", :request_id=>'123')
  end
  
  it "should cancel a hit" do
    hit = SharedWorkforce::Hit.define("Approve photo") { }
    hit.should_receive(:request).with(:request_id=>'123')
    SharedWorkforce::Hit.request("Approve photo", :request_id=>'123')
    
    hit.should_receive(:cancel).with(:request_id=>'123')
    SharedWorkforce::Hit.cancel("Approve photo", :request_id=>'123')
  end
  
  it "should find a hit" do
    SharedWorkforce::Hit.define("Approve photo") { }
    SharedWorkforce::Hit.define("Check profile text") { }
    SharedWorkforce::Hit.define("Check content") { }
    
    
    SharedWorkforce::Hit.find("Check profile text").name.should == "Check profile text"
    
  end
  
  it "should raise a ConfigurationError if a callback host is not set" do
    SharedWorkforce::Client.callback_host = nil
    lambda {
      SharedWorkforce::Hit.define("Approve photo") { }
    }.should raise_error SharedWorkforce::ConfigurationError
  end
  
  it "should raise a ConfigurationError if an API key is not set" do
    SharedWorkforce::Client.api_key = nil
    lambda {
      SharedWorkforce::Hit.define("Approve photo") { }
    }.should raise_error SharedWorkforce::ConfigurationError
  end
end


