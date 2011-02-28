require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  it "should load hits" do
    Hci::Client.load_path = File.dirname(__FILE__) + '/hits'
    Hci::Client.load!
    
    Hci::Hit.find("Approve photo").should_not == nil
  end
  
  it "should return the current version number" do
    Hci::Client.version.should == Hci::VERSION
  end
end


