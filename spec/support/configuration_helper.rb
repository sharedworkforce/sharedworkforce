module ConfigurationHelper
  def configure(&block)
    SharedWorkforce.configure(&block)
  end

  def with_configuration(&block)
    old_configuration = SharedWorkforce.configuration
    SharedWorkforce.configuration = SharedWorkforce::Configuration.new
    yield(SharedWorkforce.configuration)
  ensure
    SharedWorkforce.configuration = old_configuration
  end
end

RSpec.configure do |config|
  config.include ConfigurationHelper
end