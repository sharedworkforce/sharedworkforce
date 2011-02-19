module Hci
  class HitResponse
    
    def self.create_collection_from_array(ary)
      ary.collect {|r| HitResponse.new(r) }
    end
  
    attr_accessor :answer
    
    def initialize(params)
      @answer = params[:answer]
    end
  
  end
end