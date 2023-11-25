require 'json'
module SharedWorkforce
  class TaskRequest
    
    def initialize(task, params)
      @task = task
      @params = params
    end
    
    private
    
    def request_params
      [{:task=>@task.to_hash.merge(@params), :api_key=>api_key}.to_json, {:content_type => :json, :accept => :json}]
    end
    
    def http_end_point
      SharedWorkforce.configuration.http_end_point
    end
    
    def api_key
      SharedWorkforce.configuration.api_key
    end

    def task
      @task
    end
    
  end
end
