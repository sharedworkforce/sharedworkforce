require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Configuration" do

	let(:configuration) { SharedWorkforce::Configuration.new }

	describe "#api_key" do
		it "should use the API key set in ENV['SHAREDWORKFORCE_API_KEY']" do
			old_env = ENV['SHAREDWORKFORCE_API_KEY']
			ENV['SHAREDWORKFORCE_API_KEY'] = "API_KEY_FROM_ENV"
			configuration.api_key.should == "API_KEY_FROM_ENV"
			ENV['SHAREDWORKFORCE_API_KEY'] = old_env
		end

		it "should be overridable with a custom value" do
			old_env = ENV['SHAREDWORKFORCE_API_KEY']
			ENV['SHAREDWORKFORCE_API_KEY'] = "API_KEY_FROM_ENV"
			configuration.api_key = "CUSTOM_API_KEY"
			configuration.api_key.should == "CUSTOM_API_KEY"
			ENV['SHAREDWORKFORCE_API_KEY'] = old_env
		end
	end

	describe "#callback_host" do
		it "should use the callback host set in ENV['SHAREDWORKFORCE_CALLBACK_HOST']" do
			old_env = ENV['SHAREDWORKFORCE_CALLBACK_HOST']
			ENV['SHAREDWORKFORCE_CALLBACK_HOST'] = "http://env.example.com"
			configuration.callback_host.should == "http://env.example.com"
			ENV['SHAREDWORKFORCE_CALLBACK_HOST'] = old_env
		end

		it "should be overridable with a custom value" do
			old_env = ENV['SHAREDWORKFORCE_CALLBACK_HOST']
			ENV['SHAREDWORKFORCE_CALLBACK_HOST'] = "env.example.com"
			configuration.callback_host = "custom.example.com"
			configuration.callback_host.should == "custom.example.com"
			ENV['SHAREDWORKFORCE_CALLBACK_HOST'] = old_env
		end
	end
	
	describe "#callback_url" do
		it "should be nil if callback_host is nil" do
			configuration.callback_host = nil
			configuration.callback_path = "something"
			configuration.callback_url.should be_nil
		end
	  
	end
 
end