require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TaskRequest::HttpWithoutCallbacks" do
  describe "#create" do
    it "should disable callbacks" do
    	task = ApprovePhotoTask.new
      task_request = SharedWorkforce::TaskRequest::HttpWithoutCallbacks.new(task,
      	:image_url=>"http://www.google.com/logo.png",
      	:image_crop_ratio=>1.7,
      	:callback_params=>{:resource_id=>'1234'}
      )

			stub_request(:post, "https://api.sharedworkforce.com/tasks").to_return(:body=>{:id=>123}.to_json)

			task_request.create

			a_request(:post, "https://api.sharedworkforce.com/tasks").with(:body=>{'task'=>
        {
          'title'=>"Approve Photo",
          'instruction'=>"Please classify this photo by choosing the appropriate tickboxes.",
          'image_url'=>"http://www.google.com/logo.png",
          'image_crop_ratio'=>1.7,
          'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
          'responses_required'=>3,
          'answer_type'=>'tags',
          'callback_url'=>nil,
          'callback_params'=>{'resource_id'=>'1234'},
          'replace'=>true,
          'callback_enabled'=>false,
          'html'=>'<strong>Custom html</strong>'
        }, :api_key=>'test-api-key'}).should have_been_made.once
    end
  end
end
