class Hci::Hit
    
  class << self
    
    attr_accessor :hits
    
    def hits
      @hits ||= {}
    end

    def define(name, &block)
      raise "Please set your Hci api key with Hci::Client.api_key = 'your-api-key-here'" unless Hci::Client.api_key
      hit = self.new
      hit.name = name
      yield hit
      self.hits[name] = hit
    end
    
    def request(name, resource_id)
      @hits[name].request(resource_id)
    end
    
    def find(name)
      self.hits[name]
    end
    
    def clear!
      @hits = {}
    end
  
  end
  
  attr_accessor :name
  attr_accessor :directions
  attr_accessor :image_url
  attr_accessor :answer_options
  attr_accessor :total_responses_required
  attr_accessor :unique # whether hits with the same resource id and name should be overwritten
  
  def unique
    @unique ||= true
  end
  
  def request(resource_id)
    hit_request = Hci::HitRequest.new(self, resource_id)
    hit_request.invoke
  end
  
  def to_hash
    {
      :name=>name,
      :directions => directions,
      :image_url => image_url,
      :answer_options => answer_options,
      :total_responses_required => total_responses_required,
      :unique => unique
    }
  end
  
  # Callbacks
  
  def on_completion(&block)
    @on_complete_proc = block
  end
  
  def complete!(results)
    @on_complete_proc.call(results) if @on_complete_proc
  end
  
  def on_failure(&block)
    @on_failure_proc = block
  end
  
  def fail!(results)
    @on_failure_proc.call(results) if @on_failure_proc
  end
  
  
end