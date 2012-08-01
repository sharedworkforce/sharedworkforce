require 'shared_workforce/configuration'
require 'shared_workforce/exceptions'
require 'shared_workforce/client'
require 'shared_workforce/version'
require 'shared_workforce/task'
require 'shared_workforce/task_request/task_request'
require 'shared_workforce/task_request/black_hole'
require 'shared_workforce/task_request/http'
require 'shared_workforce/task_request/http_with_poller'
require 'shared_workforce/task_result'
require 'shared_workforce/task_response'
require 'shared_workforce/end_point'
require 'shared_workforce/response_poller'
require 'shared_workforce/frameworks/rails' if defined?(Rails)
require 'active_support/inflector'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'

module SharedWorkforce
    
  class << self
    attr_writer :configuration
    
    def configure
      yield(configuration); nil
    end

    def configuration
      @configuration ||= SharedWorkforce::Configuration.new
    end

    def logger
      configuration.logger
    end
  end

end