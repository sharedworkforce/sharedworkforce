require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Task" do
  it "should define a task" do
    
    SharedWorkforce::Task.define "Approve photo" do |h|
      
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
    
    SharedWorkforce::Task.tasks.first[1].directions.should == "Please classify this photo by choosing the appropriate tickboxes."
    
  end
  
  it "should run a completion callback" do
    
    object = OpenStruct.new(:test=>nil)
    
    task = SharedWorkforce::Task.define "Approve photo" do |h|
      
      h.on_completion do |result|
        object.test = "Complete"
      end
      
    end
    
    object.test.should == nil
    task.complete!({})
    object.test.should == "Complete"
  end
  
  it "should run a failure callback" do
    
    object = OpenStruct.new(:test=>nil)
    
    task = SharedWorkforce::Task.define "Approve photo" do |h|
      
      h.on_failure do |result|
        object.test = "Failed"
      end
      
    end
    
    object.test.should == nil
    task.fail!({})
    object.test.should == "Failed"
  end
  
  it "should not raise an error if there is no callback defined" do
    lambda {
      task = SharedWorkforce::Task.define("Approve photo") { }
      task.fail!({})
    }.should_not raise_error
  end
  
  it "should request a task" do
    task = SharedWorkforce::Task.define("Approve photo") { }
    task.should_receive(:request).with(:request_id=>'123')
    SharedWorkforce::Task.request("Approve photo", :request_id=>'123')
  end
  
  it "should cancel a task" do
    task = SharedWorkforce::Task.define("Approve photo") { }
    task.should_receive(:request).with(:request_id=>'123')
    SharedWorkforce::Task.request("Approve photo", :request_id=>'123')
    
    task.should_receive(:cancel).with(:request_id=>'123')
    SharedWorkforce::Task.cancel("Approve photo", :request_id=>'123')
  end
  
  it "should find a task" do
    SharedWorkforce::Task.define("Approve photo") { }
    SharedWorkforce::Task.define("Check profile text") { }
    SharedWorkforce::Task.define("Check content") { }
    
    
    SharedWorkforce::Task.find("Check profile text").name.should == "Check profile text"
    
  end
  
  it "should raise a ConfigurationError if a callback host is not set" do
    with_configuration do |config|
      config.callback_host = nil
      lambda {
        SharedWorkforce::Task.define("Approve photo") { }
      }.should raise_error SharedWorkforce::ConfigurationError
    end
  end
  
  it "should raise a ConfigurationError if an API key is not set" do
    with_configuration do |config|
      config.api_key = nil
      lambda {
        SharedWorkforce::Task.define("Approve photo") { }
      }.should raise_error SharedWorkforce::ConfigurationError
    end
  end
end


