module Hci
  class HitResult
   
    attr_accessor :callback_params
    attr_accessor :responses
    attr_accessor :name
    attr_accessor :status
    
    def initialize(params)
      self.callback_params = params['callback_params']
      self.responses = HitResponse.create_collection_from_array(params['responses'])
      self.name = params['name']
    end
    
    def answers
      responses.map(&:answer).flatten
    end
    
    def usernames
      responses.map(&:username).flatten
    end
    
    def process!
      if hit = Hit.find(name)
        hit.complete!(self)
      else
        raise "The hit #{name} could not be found"
      end
    end
   
  end
end