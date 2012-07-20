require 'rest_client'
module SharedWorkforce
  class TaskRequest::HttpWithPoller < TaskRequest

    def create
      task = JSON.parse(RestClient.post("#{http_end_point}/tasks", *request_params))
      ResponsePoller.start(task['id'])
    end
  
    def cancel
      RestClient.post("#{http_end_point}/tasks/cancel", *request_params)
    end

    def request_params
      [{:task=>@task.to_hash.merge(@params).merge(:callback_url=>callback_url, :callback_enabled=>false), :api_key=>api_key}.to_json, {:content_type => :json, :accept => :json}]
    end
  end
end