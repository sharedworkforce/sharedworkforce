module SharedWorkforce
  class ResponsePoller
    def self.start(task_id)
      Thread.abort_on_exception = true
      Thread.new do
        puts "SharedWorkforce: Checking every 20 seconds for responses for task #{task_id}."
        while true
          sleep 20
          puts "SharedWorkforce: Checking for task responses for task #{task_id} (development mode)"
          task = JSON.parse(RestClient.get("#{SharedWorkforce.configuration.http_end_point}/tasks/#{task_id}", {
            'X-API-Key'=>SharedWorkforce.configuration.api_key,
            :content_type => :json,
            :accept => :json
          }))
          if task['state'] == "completed"
            puts "SharedWorkforce: Task complete. Getting responses."
            responses = JSON.parse(RestClient.get("#{SharedWorkforce.configuration.http_end_point}/tasks/#{task_id}/responses", {
              'X-API-Key'=>SharedWorkforce.configuration.api_key,
              :content_type => :json,
              :accept => :json
            }))
            puts "SharedWorkforce: Processing responses."
            SharedWorkforce::TaskResult.new(responses).process!
            break;
          end
        end
      end
    end
  end
end