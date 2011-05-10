Shared Workforce Client
=======================

Shared Workforce is a platform for managing and completing repetitive tasks that require human intelligence. For example, tagging photos, approving text and answering simple questions.

It differs from other similar services in the following ways:

* All tasks should be very simple and typically take no more than 10-15 seconds. (larger tasks can be broken down in to smaller ones). 
* Tasks are displayed from a selection of pre-defined formats.
* Very simple integration via this ruby gem or the straight forward REST API.

The service is currently in private beta. You can apply for an invitation at [sharedworkforce.com](http://www.sharedworkforce.com).

Getting started
===============

### Step 1 - get an API key

Register for a beta invitation at [sharedworkforce.com](http://www.sharedworkforce.com). Once you are invited, you can create your account and retrieve your API key - which will look something like this:

    acdc30b2-14c5-46ee-ba35-11d50edc65ec

### Step 2 - add the gem
  
Add shared_workforce to your Gemfile:

    gem "shared_workforce"

Or, for Rails 2.x add the gem to your environment.rb

    config.gem "shared_workforce"

Create config/initializers/shared_workforce.rb

    SharedWorkforce.configure do |config|
      config.api_key = "your-api-key"
      config.callback_host = "http://your-website-host"
    end

If you're not using Rails, simply require the gem or include it in your Gemfile, set the client configuration settings as above.

### Step 3 - define tasks

Create a directory called 'tasks' in the root of your app. This is where you define your tasks - all files in this directory will be loaded.

If, for example, you would like to have a photo tagged on upload, create your first task in a file called tasks/tag_photo.rb

    SharedWorkforce::Task.define "Tag photo" do |t|
  
      t.directions = "Look at this photo. Please tick all that apply."
      t.answer_options = ['Offensive', 'Contains Nudity', 'Blurry or low quality']
      t.answer_type = :tags
      t.responses_required = 1
      t.replace = true

      t.on_completion do |result|
        photo = Photo.find(result.callback_params['photo_id'])
        if result.answers.include?('Offensive')
          photo.hide!
          photo.add_comment("Photo hidden because it was offensive")
        elsif result.answers.include?('Contains Nudity')
          photo.refer!
          photo.add_comment("Photo referred because it contains nudity")
        else
          photo.approve!
        end
      end

    end

### Step 4 - request tasks

Publishing tasks is simply a case of calling SharedWorkforce::Task.request(name, options).  If you are using Rails, this could be done in an after save callback on a model:

    class Photo < ActiveRecord::Base
    
      after_create :request_tags
    
      def request_tags
        SharedWorkforce::Task.request "Tag photo", {:image_url => self.url, :callback_params => { :photo_id => self.id} }
      end
    end


That's it - once your task is completed the callback you have defined in the task definition will be called. Everything you define in the :callback_params option will be sent back to your callback as shown in the example.

Advanced definition options
----------------------------------------

### Task types

SharedWorkforce currently supports 2 types of task. :tags (multiple select) and :choice (single answer from a list of options).  Free-form input is planned in the near future.

    SharedWorkforce::Task.define |t|
      t.answer_type = #:tags or :choice
    end

###Multiple responses

SharedWorkforce supports multiple responses for each task. The callback method provides you with an array of responses from multiple workers. You can create your own logic to decide what to do. This is useful if you want to prevent destructive action unless a number of workers agree.

    SharedWorkforce::Task.define "Tag photo" do |t|
  
      t.directions = "Look at this photo. Please tick all that apply."
      t.answer_options = ['Offensive', 'Contains Nudity', 'Blurry or low quality']
      t.answer_type = :tags
      t.responses_required = 3

      t.on_completion do |result|
        photo = Photo.find(result.callback_params['photo_id'])
        photo.hide! if result.answers.all? { |a| a == 'Contains Nudity' }
      end

    end

###Replacing tasks

The "replace" option allows you to overwrite or update any existing tasks with the same name and callback params. This could be useful in the example to handle the situation where a user re-uploads their photo - you may only care about the latest one.

    SharedWorkforce::Task.define "Tag photo" do |t|
      ...
      t.replace=true
      ...  
    end

###Cancelling tasks

You can cancel tasks when they are no longer relevant.
 
    class Photo < ActiveRecord::Base
      after_destroy :cancel_tagging_request

      def cancel_tagging_request
        SharedWorkforce::Task.cancel "Classify photo", :callback_params=>{:photo_id=>self.id})
      end
    end

###Testing and development

You can black-hole requests to SharedWorkforce for testing and development by adding the following configuration option in your initializer:

    SharedWorkforce.configure do |config|
      config.request_class = TaskRequest::BlackHole
    end

License
-----------

The SharedWorkforce Client is (c) [Pigment](http://www.thinkpigment.com) and released under the MIT license

