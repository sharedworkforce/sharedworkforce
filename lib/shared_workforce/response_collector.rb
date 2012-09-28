module SharedWorkforce
  class ResponseCollector

    attr_accessor :interval

    def self.start(interval=nil)
      new.start(interval)
    end

    def start(interval)
      @interval = interval   
      process_tasks completed_tasks
      sleep interval if interval
    end

    private

    def process_tasks(tasks)
      if tasks.any?
        tasks.each do |task|
          if task['state'] == "completed"
            SharedWorkforce.logger.info "=> #{task['title']} (#{task['id']}) complete. Loading responses."
            responses = collect_responses(task['id'])

            SharedWorkforce::TaskResult.new(responses).process!
            SharedWorkforce.logger.info "=> Done."
          end
        end
      elsif !interval
        SharedWorkforce.logger.info "=> No responses to collect."
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