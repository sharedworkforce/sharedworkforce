require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  it "should return the current version number" do
    SharedWorkforce::Client.version.should == SharedWorkforce::VERSION
  end
end


