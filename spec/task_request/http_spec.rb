require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TaskRequest::Http" do
  describe "#create" do
    it "should invoke a task request" do
      
      task = ApprovePhotoTask.new
      task_request = SharedWorkforce::TaskRequest::Http.new(task, :image_url=>"http://www.google.com/logo.png", :callback_params=>{:resource_id=>'1234'})
    
      stub_request(:post, "api.sharedworkforce.com/tasks")
      task_request.create
      a_request(:post, "http://api.sharedworkforce.com/tasks").with(:body=>{'task'=>
        {
          'title'=>"Approve Photo",
          'instruction'=>"Please classify this photo by choosing the appropriate tickboxes.",
          'image_url'=>"http://www.google.com/logo.png",
          'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
          'responses_required'=>3,
          'answer_type'=>'tags',
          'callback_url'=>"#{SharedWorkforce.configuration.callback_host}/hci_task_result",
          'callback_params'=>{'resource_id'=>'1234'},
          'replace'=>true
        }, :api_key=>'test-api-key'}).should have_been_made.once
    
    end
    
    it "should allow options to be overridden when making the request" do     
      task = Class.new do
        include SharedWorkforce::Task
 
        title 'Approve Photo'
        instruction 'Please classify this photo by choosing the appropriate tickboxes.'
        responses_required 3
        image_url "http://www.google.com/logo.png"
        answer_type :tags
        replace false
 
        answer_options ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children']
      end

      task_request = SharedWorkforce::TaskRequest::Http.new(task.new, {:callback_params=>{:resource_id=>'1234'}, :image_url=>"http://www.example.com/image.jpg"})

      stub_request(:post, "api.sharedworkforce.com/tasks")
      task_request.create
      a_request(:post, "http://api.sharedworkforce.com/tasks").with(:body=>{'task'=>
        {
          'title'=>"Approve Photo",
          'instruction'=>"Please classify this photo by choosing the appropriate tickboxes.",
          'image_url'=>"http://www.example.com/image.jpg",
          'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
          'responses_required'=>3,
          'answer_type'=>'tags',
          'callback_url'=>"#{SharedWorkforce.configuration.callback_host}/hci_task_result",
          'callback_params'=>{'resource_id'=>'1234'},
          'replace'=>false,
        }, :api_key=>'test-api-key'}).should have_been_made.once
     end
  end
  
  describe "#cancel" do
    it "should invoke a task cancellation" do
    
      task_request = SharedWorkforce::TaskRequest::Http.new(ApprovePhotoTask.new, :callback_params=>{:resource_id=>'1234'})
    
      stub_request(:post, "api.sharedworkforce.com/tasks/cancel")
      task_request.cancel
      a_request(:post, "http://api.sharedworkforce.com/tasks/cancel").with(:body=>{'task'=>
        {
          'title'=>"Approve Photo",
          'instruction'=>"Please classify this photo by choosing the appropriate tickboxes.",
          'image_url'=>"http://www.google.com/logo.png",
          'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
          'responses_required'=>3,
          'answer_type'=>'tags',
          'callback_url'=>"#{SharedWorkforce.configuration.callback_host}/hci_task_result",
          'callback_params'=>{'resource_id'=>'1234'},
          'replace'=>true
        }, :api_key=>'test-api-key'}).should have_been_made.once
    
    end
  end 
end