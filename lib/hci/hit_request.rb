require 'rest_client'
require 'json'
module Hci
  class HitRequest
  
    def initialize(hit, resource_id)
      @hit = hit
      @resource_id = resource_id
      @http_end_point = Client.http_end_point
    end
  
    def invoke
      RestClient.post("#{@http_end_point}/hits", {:hit=>@hit.to_hash.merge(:resource_id=>@resource_id.to_s, :callback_url=>Client.callback_url), :api_key=>Client.api_key}.to_json, :content_type => :json, :accept => :json)
    end
  
  end
end