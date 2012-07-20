module SharedWorkforce
  class ResponsePoller

    def self.start(interval=60)
      new.start(interval)
    end

    def initialize
      $stdout.sync = true
    end

    def start(interval)
      Thread.abort_on_exception = true
      Thread.new do
        puts "SharedWorkforce: Checking every #{interval} seconds for new responses."
        
        while true
          puts "SharedWorkforce: Checking for new task responses."
          process_tasks completed_tasks
          sleep interval
        end
      end
    end

    private

    def process_tasks(tasks)
      tasks.each do |task|
        if task['state'] == "completed"
          puts "SharedWorkforce: Task complete. Getting responses."
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