require 'rest_client'
module SharedWorkforce
  class TaskRequest::HttpWithoutCallbacks < TaskRequest::Http
  	# Disable callbacks during development
    def request_params
      [{:task=>@task.to_hash.merge(@params).except(:callback_host).merge(:callback_url=>callback_url, :callback_enabled=>false), :api_key=>api_key}.to_json, {:content_type => :json, :accept => :json}]
    end
  end
end
