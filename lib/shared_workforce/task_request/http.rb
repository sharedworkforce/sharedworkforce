require 'rest_client'
module SharedWorkforce
  class TaskRequest::Http < TaskRequest
    
    def initialize(*args)
      raise ConfigurationError, "Please set your SharedWorkforce api key with SharedWorkforce::Client.api_key = 'your-api-key-here'" unless SharedWorkforce.configuration.valid?
      super(*args)
    end
    
    def create
      RestClient.post("#{http_end_point}/tasks", *request_params)
    end
  
    def cancel
      RestClient.post("#{http_end_point}/tasks/cancel", *request_params)
    end
  end
end