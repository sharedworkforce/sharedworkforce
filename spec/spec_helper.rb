$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'shared_workforce'
require 'rspec'
require 'rspec/autorun'
require 'webmock/rspec'

RSpec.configure do |config|
  config.color_enabled = true
  config.after :each do
    SharedWorkforce::Hit.clear!
  end
  
  config.before :each do
    SharedWorkforce::Client.api_key = "test-api-key"
    SharedWorkforce::Client.callback_host = "www.example.com"
  end
end


