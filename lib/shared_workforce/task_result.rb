module SharedWorkforce
  class TaskResult
   
    attr_accessor :callback_params
    attr_accessor :responses
    attr_accessor :name
    attr_accessor :status
    
    def initialize(params)
      self.callback_params = params['callback_params']
      self.responses = TaskResponse.create_collection_from_array(params['responses'])
      self.name = params['name']
    end
    
    def answers
      responses.map(&:answer).flatten
    end
    
    def usernames
      responses.map(&:username).flatten
    end
    
    def process!
      if task = Task.find(name)
        task.success!(self)
        task.complete!(self)
      else
        raise "The task #{name} could not be found"
      end
    end
   
  end
end