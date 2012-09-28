Shared Workforce Client
=======================

[![Build Status](https://secure.travis-ci.org/sharedworkforce/sharedworkforce.png)](http://travis-ci.org/#!/sharedworkforce/sharedworkforce)

Shared Workforce is a platform for managing and completing repetitive tasks that require human intelligence. For example, tagging and cropping photos, approving text and answering simple questions.

The Shared Workforce client lets you add behaviour to your models so that when an action occurs (for example, a photo is added), details of that action and model are sent to human workers, who can asses the data and return a response, which can be used to trigger further actions in the model (for example, marking it as spam).

You can view a live demo sandbox app at [http://catsify.herokuapp.com](http://catsify.herokuapp.com)

The service is currently in private beta and is available as a [Heroku add-on](https://addons.heroku.com/sharedworkforce). You can apply for an invitation at [sharedworkforce.com](http://www.sharedworkforce.com).


Getting started
===============

_**Note to Heroku users:** Getting started with [Heroku](http://www.heroku.com]) takes less than 5 minutes. The best way to get started is to follow the README on the [demo app source code](https://github.com/sharedworkforce/sharedworkforce-demo-rails)._

### Step 1 - get an API key

Register for a beta invitation at [sharedworkforce.com](http://www.sharedworkforce.com). Once you are invited, you can create your account and retrieve your API key - which will look something like this:

    acdc30b2-14c5-46ee-ba35-11d50edc65ec

### Step 2 - add the gem
  
Add shared_workforce to your Gemfile:

```ruby
gem "shared_workforce"
```

Create config/initializers/shared_workforce.rb

```ruby
SharedWorkforce.configure do |config|
  config.api_key = "your-api-key"
  config.callback_host = "http://your-website-host"
end
```

If you're not using Rails, simply require the gem or include it in your Gemfile, set the client configuration settings as above.

### Step 3 - define tasks

A class defines the content (for example, an image url) and instructions that the human worker will see when they work on your task, and the methods to be run once the task has been completed.

If, for example, you would like to approve a photo on upload, create a task class file in an `app/tasks` directory (or anywhere in the load path).


`app/tasks/tag_photo_task.rb`:

```ruby
class TagPhotoTask
  include SharedWorkforce::Task
  
  title 'Please tag our photo'
  
  instruction 'Please look at the photo and tick all that apply.'
  
  answer_type :tags
  answer_options ['Offensive', 'Contains Nudity', 'Blurry or low quality', 'Upside down or sideways']
  
  responses_required 1
  
  on_success :moderate_photo
  
  def setup(photo)
    self.image_url = photo.url
  end
  
  def moderate_photo(photo, responses)
    # responses => [{:answer=>['Offensive', 'Contains Nudity']}]
    if responses.map {|r| r[:answer]}.flatten.include?('Offensive')
      photo.delete
      photo.user.quarantine("Uploded offensive photo")
    end
  end
end
```
_**Note:** the task definition includes a `setup` method which is called automatically whenever the task is initialized. In the example, the task's `image_url` (the image shown to the worker) is set from the photo model's url attribute. Any of the task's attributes can be set this way._

Class level attributes are a handy way of defining data that doesn't change between each task.
Attributes set on the instance will always override attributes set at the class level.

In most cases, you'll want to explicitly set default task values at the class level
(like `title` and `instruction`). Setting `text`
and `image_url` values (i.e. the content in question) will usually be done in
the `setup` method.</p>

Once you have created a task definition, you can request real human responses for a model instance by calling its `create` method. This can be done in an `after_create` callback in one of your Active Record models. This will be covered in more detail in the next section.

### Step 4 - request tasks

When you publish a task it will be queued for a human worker to complete. You can publish a task in an `after_create` callback on a typical Active Record model:

```ruby
class Photo < ActiveRecord::Base
  
  after_create :request_tags
  
  def request_tags
    TagPhotoTask.create(self)
  end
end
```

_**Note:** In the example, the photo model instance (self) is used an argument to the TagPhotoTask.create method. This argument will be available in the setup method and the callback method as shown in the example of a Task Definition in step 3._

When the response(s) from the human workers are collected, the method specified in the `on_success` attribute in your task definition will be called. Typically this will take about 15 minutes. You can check the [Shared Workforce web site](http://www.sharedworkforce.com) for an up to date status on the current response time.

### Step 5 - collect responses

A rake task is provided for collecting the responses *during development*.

```
$ rake sw:collect
```

There is no requirement to run the rake task in production. The webhook will be used to deliver the task responses.

### Unit testing

You can test your task definition by calling its methods directly.

```ruby
it "should quarantine the user" do
  photo = Factory(:photo)
  task = ClassifyPhotoTask.new(photo)
  task.moderate_photo(photo, [{:answer=>['Offensive']}])
  photo.user.should be_quarantined
end
```

Advanced definition options
----------------------------------------

### Task types

SharedWorkforce currently supports 5 types of task. Possible options are:

  * `"choice"`: choose one option from a list
  * `"tags"`: choose any number of options from a list
  * `"edit"`: edit the text in the 'text' attribute
  * `"crop"`: crop the photo (see image_crop_ratio)
  * `"rotate"`: rotate the photo

### Multiple responses

SharedWorkforce supports multiple responses for each task. The callback method provides you with an array of responses from multiple workers. You can create your own logic to decide what to do. This is useful if you want to prevent destructive action unless a number of workers agree.

```ruby
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
```

### Replacing tasks

The "replace" option allows you to overwrite or update any existing tasks with the same name and callback params. This could be useful in the example to handle the situation where a user re-uploads their photo - you may only care about the latest one.

```ruby
class ApprovePhotoTask
  include SharedWorkforce::Task
  ...
  replace true
  ...  
end
```

### Cancelling tasks

You can cancel tasks when they are no longer relevant.

```ruby 
class Photo
  after_destroy :cancel_tagging_request

  def cancel_tagging_request
    ApprovePhotoTask.cancel(self)
  end
end
```

### Disabling requests during development

You can black-hole requests to Shared Workforce for testing and development by adding the following configuration option in your initializer:

```ruby
SharedWorkforce.configure do |config|
  config.request_class = SharedWorkforce::TaskRequest::BlackHole
end
```

License
-----------

The SharedWorkforce Client is (c) [Pigment](http://www.thinkpigment.com) and released under the MIT license

