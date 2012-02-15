$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'shared_workforce'
require 'rspec'
require 'rspec/autorun'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.expand_path('../support', __FILE__), '**/*.rb')].each {|f| require f}
Dir[File.join(File.expand_path('../tasks', __FILE__), '**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.color_enabled = true
  
  config.before :each do
    SharedWorkforce.configure do |config|
      config.api_key = "test-api-key"
      config.callback_host = "www.example.com"
    end
  end
end


