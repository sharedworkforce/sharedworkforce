require 'rest_client'
module SharedWorkforce
  class TaskRequest::BlackHole < TaskRequest  
    def create; end
    def cancel; end
  end
end