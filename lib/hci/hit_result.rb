module Hci
  class HitResult
   
    attr_accessor :callback_params
    attr_accessor :answer
    attr_accessor :name
    attr_accessor :status
  
    def initialize(params)
      self.callback_params = params['callback_params']
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