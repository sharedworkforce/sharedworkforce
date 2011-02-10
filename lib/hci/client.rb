class Hci::Client
  
  @http_end_point = "http://hci.heroku.com"
  @load_path = "hits"
  
  class << self
    attr_accessor :api_key
    attr_accessor :load_path
    attr_accessor :http_end_point
    
    def load!
      Dir[File.join(load_path, "*.rb")].each do |file|
        load file
      end
    end
    
  end
  
end