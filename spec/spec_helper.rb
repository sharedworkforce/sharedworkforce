$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hci'
require 'rspec'
require 'rspec/autorun'
require 'webmock/rspec'

Hci::Client.api_key = "test-api-key"

RSpec.configure do |config|
  config.color_enabled = true
  config.after :each do
    Hci::Hit.clear!
  end
end


