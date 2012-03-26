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
  end
end