require 'shared_workforce/configuration'
require 'shared_workforce/exceptions'
require 'shared_workforce/client'
require 'shared_workforce/version'
require 'shared_workforce/task'
require 'shared_workforce/task_request'
require 'shared_workforce/task_result'
require 'shared_workforce/task_response'
require 'shared_workforce/end_point'
require 'shared_workforce/frameworks/rails' if defined?(Rails)

module SharedWorkforce
  
  class << self
    
    attr_writer :configuration
    
    def configure
      yield(configuration); nil
    end

    def configuration
      @configuration ||= SharedWorkforce::Configuration.new
    end
  end
  
end