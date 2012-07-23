module SharedWorkforce
  class ResponsePoller
    # The response poller is intended for use during local development only. It 
    # facilitates real world task responses without needing an open socket for the 
    # web hooks.

    def self.start(interval=60)
      new.start(interval)
    end

    def start(interval)
      Thread.abort_on_exception = true
      Thread.new do
        SharedWorkforce.logger.info "SharedWorkforce: Checking every #{interval} seconds for new responses."
        
        while true
          SharedWorkforce.logger.info "SharedWorkforce: Checking for new task responses."
          process_tasks completed_tasks
          sleep interval
        end
      end
    end

    private

    def process_tasks(tasks)
      tasks.each do |task|
        if task['state'] == "completed"
          SharedWorkforce.logger.info "SharedWorkforce: Task complete. Getting responses."
          responses = collect_responses(task['id'])
          SharedWorkforce::TaskResult.new(responses).process!
        end
      end
    end

    def completed_tasks
      JSON.parse(RestClient.get("#{SharedWorkforce.configuration.http_end_point}/tasks/unreturned", {
        'X-API-Key'=>SharedWorkforce.configuration.api_key,
        :content_type => :json,
        :accept => :json
      }))
    end

    def collect_responses(id)
      JSON.parse(RestClient.get("#{SharedWorkforce.configuration.http_end_point}/tasks/#{id}/responses/collect", {
        'X-API-Key'=>SharedWorkforce.configuration.api_key,
        :content_type => :json,
        :accept => :json
      }))
    end
  end
end