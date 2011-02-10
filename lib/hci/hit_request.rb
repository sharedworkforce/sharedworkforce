require 'rest_client'
require 'json'
class Hci::HitRequest
  
  def initialize(hit, resource_id)
    @hit = hit
    @resource_id = resource_id
    @http_end_point = Hci::Client.http_end_point
  end
  
  def invoke
    RestClient.post("#{@http_end_point}/hits", {:name => @hit.name, :resource_id => @resource_id.to_s, :api_key=>Hci::Client.api_key}.to_json, :content_type => :json, :accept => :json)
  end
  
end