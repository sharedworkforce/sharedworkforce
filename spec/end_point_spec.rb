require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rack'
describe "EndPoint" do

  describe "#process_request" do
    it "should not raise a security transgression with a valid api key" do
      lambda {
        SharedWorkforce::EndPoint.new.process_response({:api_key => SharedWorkforce.configuration.api_key}.to_json)
      }.should_not raise_error(SharedWorkforce::SecurityTransgression)
    end

    it "should raise a security transgression with an invalid api key" do
      lambda {
        SharedWorkforce::EndPoint.new.process_response({:api_key=>'GIBBERISH'}.to_json)
      }.should raise_error(SharedWorkforce::SecurityTransgression)
    end

    it "should raise a security transgression with a missing api key" do
      lambda {
        SharedWorkforce::EndPoint.new.process_response({}.to_json)
      }.should raise_error(SharedWorkforce::SecurityTransgression)
    end
  end

end