require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HitRequest" do
  
  it "should invoke a hit request" do
    
    hit = Hci::Hit.define "Approve photo" do |h|

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
    
    hit_request = Hci::HitRequest.new(hit, :callback_params=>{:resource_id=>'1234'})
    
    stub_request(:post, "hci.heroku.com/hits")
    hit_request.invoke
    a_request(:post, "http://hci.heroku.com/hits").with(:body=>{'hit'=>
      {
        'name'=>"Approve photo",
        'directions'=>"Please classify this photo by choosing the appropriate tickboxes.",
        'image_url'=>"http://www.google.com/logo.png",
        'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
        'responses_required'=>3,
        'answer_type'=>'tags',
        'callback_url'=>"#{Hci::Client.callback_host}/hci_hit_result",
        'callback_params'=>{'resource_id'=>'1234'},
        'replace'=>false
      }, :api_key=>'test-api-key'}).should have_been_made.once
    
  end
  
  it "should allow options to be overridden when making the request" do
    
    hit = Hci::Hit.define "Approve photo" do |h|

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
    
    hit_request = Hci::HitRequest.new(hit, {:callback_params=>{:resource_id=>'1234'}, :image_url=>"http://www.example.com/image.jpg"})
    
    stub_request(:post, "hci.heroku.com/hits")
    hit_request.invoke
    a_request(:post, "http://hci.heroku.com/hits").with(:body=>{'hit'=>
      {
        'name'=>"Approve photo",
        'directions'=>"Please classify this photo by choosing the appropriate tickboxes.",
        'image_url'=>"http://www.example.com/image.jpg",
        'answer_options'=> ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children'],
        'responses_required'=>3,
        'answer_type'=>'tags',
        'callback_url'=>"#{Hci::Client.callback_host}/hci_hit_result",
        'callback_params'=>{'resource_id'=>'1234'},
        'replace'=>false,
      }, :api_key=>'test-api-key'}).should have_been_made.once
  end
  
end


