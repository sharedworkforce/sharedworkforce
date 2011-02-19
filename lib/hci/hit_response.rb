module Hci
  class HitResponse
    
    def self.create_collection_from_array(ary)
      ary.collect {|r| HitResponse.new(r) }
    end
  
    attr_accessor :answer, :callback_params
    
    def initialize(params)
      @answer = params['answer']
      @callback_params = params['callback_params']
    end
  
  end
end