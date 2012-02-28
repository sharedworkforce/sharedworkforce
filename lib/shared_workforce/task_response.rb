module SharedWorkforce
  class TaskResponse
    
    def self.create_collection_from_array(ary)
      ary.collect {|r| TaskResponse.new(r) }
    end
    
    def to_hash
      {:answer=>answer, :answered_by=>username}
    end

    attr_accessor :answer, :callback_params, :username
    
    def initialize(params)
      @answer = params['answer']
      @callback_params = params['callback_params']
      @username = params['username']
    end
  
  end
end