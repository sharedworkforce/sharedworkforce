module SharedWorkforce
  class TaskResult
   
    attr_accessor :callback_params
    attr_accessor :responses
    attr_accessor :name
    attr_accessor :status
    
    def initialize(params)
      self.callback_params = params['callback_params']
      @responses = TaskResponse.create_collection_from_array(params['responses']) if params['responses']
      self.name = params['name']
    end
    
    def responses
      @responses.map(&:to_hash)
    end
    
    def usernames
      @responses.map(&:username).flatten
    end
    
    def process!
      if task = find_task(name)
        task.new(self)
      else
        raise "The task #{name} could not be found"
      end
    end
   
  private
    def find_task(name)
      "#{name.gsub(' ', '_').classify}Task".constantize
    end
  end
end