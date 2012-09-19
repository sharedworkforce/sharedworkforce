require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Configuration" do

	let(:configuration) { SharedWorkforce::Configuration.new }

	describe "#api_key" do
		it "should use the API key set in ENV['SHAREDWORKFORCE_API_KEY']" do
			with_env 'SHAREDWORKFORCE_API_KEY', 'API_KEY_FROM_ENV' do
			 configuration.api_key.should == "API_KEY_FROM_ENV"
			end
		end

		it "should be overridable with a custom value" do
			with_env 'SHAREDWORKFORCE_API_KEY', 'API_KEY_FROM_ENV' do
  			configuration.api_key = "CUSTOM_API_KEY"
  			configuration.api_key.should == "CUSTOM_API_KEY"
      end
		end
	end

	describe "#callback_host" do
		it "should use the callback host set in ENV['SHAREDWORKFORCE_CALLBACK_HOST']" do
			with_env 'SHAREDWORKFORCE_CALLBACK_HOST', "http://env.example.com" do
			  configuration.callback_host.should == "http://env.example.com"
			end
		end

		it "should be overridable with a custom value" do
			with_env 'SHAREDWORKFORCE_CALLBACK_HOST', "env.example.com" do
  			configuration.callback_host = "custom.example.com"
  			configuration.callback_host.should == "custom.example.com"
      end
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
			with_env 'SHAREDWORKFORCE_API_KEY', nil do
			  configuration.should_not be_valid
      end
		end

    it "should be true if the api key is set in ENV" do
      with_env 'SHAREDWORKFORCE_API_KEY', 'SOMETHING' do
        configuration.should be_valid
      end
    end
	end

  def with_env(key, value, &block)
    old_value = ENV[key]
    ENV[key] = value
    yield
    ENV[key] = old_value
  end
 
end