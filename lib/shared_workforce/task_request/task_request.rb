require 'json'
module SharedWorkforce
  class TaskRequest
    
    def initialize(task, params)
      @task = task
      @params = params
    end
    
    private
    
    def request_params
      [{:task=>@task.to_hash.merge(:callback_url=>callback_url).merge(@params).except(:callback_host), :api_key=>api_key}.to_json, {:content_type => :json, :accept => :json}]
    end
    
    def http_end_point
      SharedWorkforce.configuration.http_end_point
    end

    def callback_url
      @task.callback_host.to_s + '/' + SharedWorkforce.configuration.callback_path.to_s if @task.callback_host
    end
    
    def api_key
      SharedWorkforce.configuration.api_key
    end

    def task
      @task
    end
    
  end
end
