$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hci'
require 'rspec'
require 'rspec/autorun'
require 'webmock/rspec'

RSpec.configure do |config|
  config.color_enabled = true
  config.after :each do
    Hci::Hit.clear!
  end
  
  config.before :each do
    Hci::Client.api_key = "test-api-key"
    Hci::Client.callback_host = "www.example.com"
  end
end


