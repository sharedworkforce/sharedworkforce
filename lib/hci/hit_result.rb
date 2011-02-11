module Hci
  class HitResult
   
    attr_accessor :resource_id
    attr_accessor :answer
    attr_accessor :name
    attr_accessor :status
  
    def initialize(params)
      self.resource_id = params['resource_id'].to_s
      self.answer = params['answer']
      self.name = params['name']
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