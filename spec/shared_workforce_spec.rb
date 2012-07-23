require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SharedWorkforce" do
  describe "#logger" do
    it "should return the configured logger" do
      with_configuration do |c|
        c.logger = logger = double(:logger)

        SharedWorkforce.logger.should == logger
      end
    end
  end
end