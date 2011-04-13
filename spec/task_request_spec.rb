require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskRequest" do
  
  it "should invoke a task request" do
    
    task = SharedWorkforce::Task.define "Approve photo" do |h|

      h.directions = "Please classify this photo by choosing the appropriate tickboxes."
      h.image_url = "http://www.google.com/logo.png"
      h.answer_type = "tags"
      h.answer_options = ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children']
      h.responses_required = 3
      h.replace = false
      
      h.on_completion do |result|
        puts "Complete"
      end

      h.on_failure do |result|
        puts "Failed"
      end

    end
    
    task_request = SharedWorkforce::TaskRequest.new(task, :callback_params=>{:resource_id=>'1234'})
    
    stub_request(:post, "hci.heroku.com/tasks")
    task_request.create
    a_request(:post, "http://hci.heroku.com/tasks").with(:body=>{'task'=>
      {
        'name'=>"Approve photo",
        'directions'=>"Please classify this photo by choosing the appropriate tickboxes.",
        'image_url'=>"http://www.google.com/logo.png",
        'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
        'responses_required'=>3,
        'answer_type'=>'tags',
        'callback_url'=>"#{SharedWorkforce::Client.callback_host}/hci_task_result",
        'callback_params'=>{'resource_id'=>'1234'},
        'replace'=>false
      }, :api_key=>'test-api-key'}).should have_been_made.once
    
  end
  
  
  it "should invoke a task cancellation" do
    
    task = SharedWorkforce::Task.define "Approve photo" do |h|

      h.directions = "Please classify this photo by choosing the appropriate tickboxes."
      h.image_url = "http://www.google.com/logo.png"
      h.answer_type = "tags"
      h.answer_options = ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children']
      h.responses_required = 3
      h.replace = false
      
      h.on_completion do |result|
        puts "Complete"
      end

      h.on_failure do |result|
        puts "Failed"
      end

    end
    
    task_request = SharedWorkforce::TaskRequest.new(task, :callback_params=>{:resource_id=>'1234'})
    
    stub_request(:post, "hci.heroku.com/tasks/cancel")
    task_request.cancel
    a_request(:post, "http://hci.heroku.com/tasks/cancel").with(:body=>{'task'=>
      {
        'name'=>"Approve photo",
        'directions'=>"Please classify this photo by choosing the appropriate tickboxes.",
        'image_url'=>"http://www.google.com/logo.png",
        'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
        'responses_required'=>3,
        'answer_type'=>'tags',
        'callback_url'=>"#{SharedWorkforce::Client.callback_host}/hci_task_result",
        'callback_params'=>{'resource_id'=>'1234'},
        'replace'=>false
      }, :api_key=>'test-api-key'}).should have_been_made.once
    
  end
  
  it "should allow options to be overridden when making the request" do
    
    task = SharedWorkforce::Task.define "Approve photo" do |h|

      h.directions = "Please classify this photo by choosing the appropriate tickboxes."
      h.image_url = "http://www.google.com/logo.png"
      h.answer_type = "tags"
      h.answer_options = ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children']
      h.responses_required = 3

      h.on_completion do |result|
        puts "Complete"
      end

      h.on_failure do |result|
        puts "Failed"
      end

    end
    
    task_request = SharedWorkforce::TaskRequest.new(task, {:callback_params=>{:resource_id=>'1234'}, :image_url=>"http://www.example.com/image.jpg"})
    
    stub_request(:post, "hci.heroku.com/tasks")
    task_request.create
    a_request(:post, "http://hci.heroku.com/tasks").with(:body=>{'task'=>
      {
        'name'=>"Approve photo",
        'directions'=>"Please classify this photo by choosing the appropriate tickboxes.",
        'image_url'=>"http://www.example.com/image.jpg",
        'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
        'responses_required'=>3,
        'answer_type'=>'tags',
        'callback_url'=>"#{SharedWorkforce::Client.callback_host}/hci_task_result",
        'callback_params'=>{'resource_id'=>'1234'},
        'replace'=>false,
      }, :api_key=>'test-api-key'}).should have_been_made.once
  end
  
end


