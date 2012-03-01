Shared Workforce Client
=======================

[![Build Status](https://secure.travis-ci.org/samoli/shared-workforce.png)](http://travis-ci.org/#!/samoli/shared-workforce)

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

If, for example, you would like to approve a photo on upload, create your first task in a file called tasks/approve_photo.rb   
    
    class ApprovePhotoTask
      include SharedWorkforce::Task

      title 'Approve Photo'

      instruction 'Look at this photo. Please tick all that apply.'
      responses_required 1

      answer_options ['Offensive', 'Contains Nudity', 'Blurry or low quality', 'Upside down or sideways']
      answer_type :tags
      image_url "http://www.google.com/logo.png"

      on_success :moderate_photo

      def moderate_photo(photo, responses)
        if responses.map { |r| r[:answer] }.include?('Offensive')
          photo.hide!
          photo.add_comment("Photo is offensive")
        end
        puts "Photo Moderated"
      end
      
    end
    

### Step 4 - request tasks

Publishing tasks is simply a case of calling `TaskClass.create()`.  If you are using Rails, this could be done in an after save callback on a model:

    class Photo < ActiveRecord::Base
    
      after_create :approve_photo
    
      def approve_photo
        ApprovePhotoTask.create(self)
      end
    end


Advanced definition options
----------------------------------------

### Task types

SharedWorkforce currently supports 3 types of task. `:tags` (multiple select), `:choice` (single answer from a list of options), or `:edit` (edit text).

###Multiple responses

SharedWorkforce supports multiple responses for each task. The callback method provides you with an array of responses from multiple workers. You can create your own logic to decide what to do. This is useful if you want to prevent destructive action unless a number of workers agree.

    class ApprovePhotoTask
      include SharedWorkforce::Task

      title 'Approve Photo'

      instruction 'Look at this photo. Please tick all that apply.'
      responses_required 3

      answer_options ['Offensive', 'Contains Nudity', 'Blurry or low quality', 'Upside down or sideways']
      answer_type :tags

      on_complete :moderate_photo

      def moderate_photo(photo, responses)
        photo.hide! if responses.map { |r| r[:answer] }.all? { |a| a.include?('Contains Nudity') }
      end

    end
    

###Replacing tasks

The "replace" option allows you to overwrite or update any existing tasks with the same name and callback params. This could be useful in the example to handle the situation where a user re-uploads their photo - you may only care about the latest one.

    class ApprovePhotoTask
      include SharedWorkforce::Task
      ...
      replace true
      ...  
    end

###Cancelling tasks

You can cancel tasks when they are no longer relevant.
 
    class Photo
      after_destroy :cancel_tagging_request

      def cancel_tagging_request
        ApprovePhotoTask.cancel(self)
      end
    end

###Testing and development

You can black-hole requests to SharedWorkforce for testing and development by adding the following configuration option in your initializer:

    SharedWorkforce.configure do |config|
      config.request_class = SharedWorkforce::TaskRequest::BlackHole
    end

License
-----------

The SharedWorkforce Client is (c) [Pigment](http://www.thinkpigment.com) and released under the MIT license

