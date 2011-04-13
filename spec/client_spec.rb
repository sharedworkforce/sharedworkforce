require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  it "should load tasks" do
    SharedWorkforce::Client.load_path = File.dirname(__FILE__) + '/tasks'
    SharedWorkforce::Client.load!
    
    SharedWorkforce::Task.find("Approve photo").should_not == nil
  end
  
  it "should return the current version number" do
    SharedWorkforce::Client.version.should == SharedWorkforce::VERSION
  end
end


