require 'rest_client'
module SharedWorkforce
  class BlackHoleTaskRequest < TaskRequest
    def create; end
    def cancel; end
  end
end