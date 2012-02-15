require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TaskRequest::BlackHole" do
  describe "#create" do
    it "should not make an HTTP request" do
      task_request = SharedWorkforce::TaskRequest::BlackHole.new(ApprovePhotoTask.new, :callback_params=>{:resource_id=>'1234'})
      task_request.create
      a_request(:any, "api.sharedworkforce.com/tasks").should_not have_been_made
    end
  end 
  
  describe "#cancel" do
    it "should not make an HTTP request" do
      task_request = SharedWorkforce::TaskRequest::BlackHole.new(ApprovePhotoTask.new, :callback_params=>{:resource_id=>'1234'})
      task_request.create
      a_request(:any, "api.sharedworkforce.com/tasks/cancel").should_not have_been_made
    end
  end
end