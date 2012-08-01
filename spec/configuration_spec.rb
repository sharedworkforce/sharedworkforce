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

	describe "#logger" do
		it "should default to rails logger" do
			logger_double = double(:logger)
			configuration.stub(:rails_logger).and_return(logger_double)
			configuration.logger.should == logger_double
		end

		it "should fallback to a default logger" do
			logger_double = double(:logger)
			configuration.stub(:rails_logger).and_return(nil)
			configuration.stub(:default_logger).and_return(logger_double)
			configuration.logger.should == logger_double
		end

		it "should be overridden by a custom logger" do
			logger_double = double(:logger)
			configuration.stub(:rails_logger).and_return(double(:rails_logger))
			configuration.logger = logger_double
			
			configuration.logger.should == logger_double
		end
	end

	describe "#valid" do
		it "should be false if no api key is set" do
			configuration.api_key = nil
			configuration.should_not be_valid
		end
	end
 
end