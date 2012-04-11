module SharedWorkforce
  class TaskResponse
    
    def self.create_collection_from_array(ary)
      ary.collect {|r| TaskResponse.new(r) }
    end
    
    def to_hash
      {:answer=>answer, :answered_by=>username, :new_image_url=>new_image_url}.reject {|k,v| v.nil? }
    end

    attr_accessor :answer, :callback_params, :username, :new_image_url
    
    def initialize(params)
      @answer = params['answer']
      @callback_params = params['callback_params']
      @username = params['username']
      @new_image_url = params['new_image_url']
    end
  
  end
end