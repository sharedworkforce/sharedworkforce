require 'rest_client'
require 'json'
module SharedWorkforce
  class TaskRequest
  
    def initialize(task, params)
      @task = task
      @params = params
    end
  
    def create
      RestClient.post("#{http_end_point}/tasks", *request_params)
    end
    
    def cancel
      RestClient.post("#{http_end_point}/tasks/cancel", *request_params)
    end
    
    private
    
    def request_params
      [{:task=>@task.to_hash.merge(@params).merge(:callback_url=>callback_url), :api_key=>api_key}.to_json, {:content_type => :json, :accept => :json}]
    end
    
    def http_end_point
      SharedWorkforce.configuration.http_end_point
    end
    
    def callback_url
      SharedWorkforce.configuration.callback_url
    end
    
    def api_key
      SharedWorkforce.configuration.api_key
    end
    
  end
end