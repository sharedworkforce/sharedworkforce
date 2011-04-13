require 'rest_client'
require 'json'
module SharedWorkforce
  class TaskRequest
  
    def initialize(task, params)
      @task = task
      @params = params
      @http_end_point = Client.http_end_point
    end
  
    def create
      RestClient.post("#{@http_end_point}/tasks", *request_params)
    end
    
    def cancel
      RestClient.post("#{@http_end_point}/tasks/cancel", *request_params)
    end
    
    private
    
    def request_params
      [{:task=>@task.to_hash.merge(@params).merge(:callback_url=>Client.callback_url), :api_key=>Client.api_key}.to_json, {:content_type => :json, :accept => :json}]
    end
    
  end
end