require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ostruct'

describe "Task" do

  before(:each) do
    @resource_class = Class.new { def self.name; "Resource"; end; def self.find; end; def id; 333; end }
  end

  it "should define a task with default attributes" do
    task_class = Class.new do
      include SharedWorkforce::Task

      title 'Approve Photo'
      instruction 'Please classify this photo by choosing the appropriate tickboxes.'
      responses_required 3
      image_url "http://www.google.com/logo.png"
      answer_type :crop
      image_crop_ratio 1.7
      guidelines "* be careful"
      html "<strong>Custom html</strong>"

      answer_options ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways']

      on_complete :puts_complete
      on_failure :puts_failure

      def puts_complete(results)
        puts "Complete"
      end

      def puts_failure(results)
        puts "Failure"
      end
    end
    
    task = task_class.new
    task.instruction.should == "Please classify this photo by choosing the appropriate tickboxes."
    task.title.should == "Approve Photo"
    task.responses_required.should == 3
    task.image_url.should == "http://www.google.com/logo.png"
    task.image_crop_ratio.should == 1.7
    task.answer_options.should == ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways']
    task.guidelines.should == "* be careful"
    task.html.should == "<strong>Custom html</strong>"
  end

  it "should allow certain default attributes to be overwritten" do
    task_class = Class.new do
      include SharedWorkforce::Task

      title 'Approve Photo'
      instruction 'Please classify this photo by choosing the appropriate tickboxes.'
      responses_required 3
      image_url "http://www.google.com/logo.png"
      replace false

      answer_options ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways']

      text "A photo"

      on_complete :puts_complete
      on_failure :puts_failure

      def puts_complete(results)
        puts "Complete"
      end

      def puts_failure(results)
        puts "Failure"
      end
    end
    
    task = task_class.new
    
    task.image_url = "http://www.bing.com"
    task.answer_options = ['Poor quality']
    task.responses_required = 10
    task.instruction = nil
    task.replace = true

    task.image_url.should == "http://www.bing.com"
    task.answer_options.should == ['Poor quality']
    task.responses_required.should == 10
    task.instruction.should == nil
    task.replace.should == true
    task.text.should == "A photo"
  end

  describe ".new" do
    it "should set the attributes from the task result callback params" do
      task_class = Class.new { include SharedWorkforce::Task; on_success :do_work; def do_work(*args); end; def setup(*args); end }
      task_class.any_instance.should_receive(:success!)
      task_class.any_instance.should_receive(:complete!)
      task = task_class.new(SharedWorkforce::TaskResult.new({'task'=>{'callback_params'=>{'key'=>'value'}}}))
      task.attributes[:key].should == 'value'
    end
  end

  describe ".create" do
    it "should create a new task instance" do
      resource = @resource_class.new
      task_class = Class.new { include SharedWorkforce::Task }
      task_class.any_instance.should_receive(:request)
      task = task_class.create(resource, :field=>'name')
      task.resource.should == resource
      task.attributes[:field].should == 'name'
    end

    it "should pass the arguments through to Task#request" do
      resource = @resource_class.new
      task_class = Class.new { include SharedWorkforce::Task }
      task_class.any_instance.should_receive(:request)
      task_class.create(resource, :field=>'name')
    end
  end
  
  describe "#process_result" do
    it "should call success! and complete! with the results" do # Will become more important once we have task failure event handling
      task_class = Class.new { include SharedWorkforce::Task; on_success :do_work; def do_work(*args); end; def setup(*args); end }
      task = task_class.new
      task.should_receive(:success!)
      task.should_receive(:complete!)
      task.process_result(SharedWorkforce::TaskResult.new({}))
    end
  end

  describe "the callback" do

    before(:each) do
      @task_class = Class.new { 
        include SharedWorkforce::Task
        on_success :do_work
        on_complete :do_log
        on_failure :try_again
        def do_work(*args); end;
        def setup(*args); end
      }

      @resource = @resource_class.new
      @task = @task_class.new(@resource)
      @result = SharedWorkforce::TaskResult.new(
        {
         'responses'=>[
            {'answer'=>'yes', 'username'=>'bilbo'},
            {'answer'=>'no', 'username'=>'frodo'},
            {'answer'=>'yes', 'username'=>'sam'}
          ],
        'name'=>"Approve photo",
        'callback_params'=>@task.attributes
        }
      )
    end
    
    describe "#success!" do
      it "should run a success callback" do
        @task.should_receive(:do_work)
        @task.success!(@result)
      end

      it "should pass the resource to the callback method as the first argument and the result as the second argument" do
        result = SharedWorkforce::TaskResult.new({'task'=>{'callback_params'=>@task.attributes}})
        @task.should_receive(:do_work).with(@resource, @result.responses)
        @task.success!(@result)
      end
    end

    describe "#complete!" do
      it "should run a complete callback" do
        @task.should_receive(:do_log)
        @task.complete!(@result)
      end

      it "should pass the resource to the callback method as the first argument and the result as the second argument" do
        result = SharedWorkforce::TaskResult.new({})
        @task.should_receive(:do_log).with(@resource, @result.responses)
        @task.complete!(@result)
      end
    end

    describe "#fail!" do
      it "should run a failure callback" do
        @task.should_receive(:try_again)
        @task.fail!(@result)
      end

      it "should pass the resource to the callback method as the first argument and the result as the second argument" do
        result = SharedWorkforce::TaskResult.new({})
        @task.should_receive(:try_again).with(@resource, @result.responses)
        @task.fail!(@result)  
      end

      it "should not raise an error if there is no callback defined" do
        lambda {
          task = Class.new { include SharedWorkforce::Task }
          task.new.fail!({})
        }.should_not raise_error
      end
    end
  end

  describe ".new" do
    before do
      @task_class = Class.new { include SharedWorkforce::Task; def setup(*args); end }
    end

    it "should call setup after initialization" do
      @task_class.any_instance.should_receive(:setup).once
      @task_class.new
    end

    it "should pass the resource as an argument to setup" do
      @resource = @resource_class.new
      @task_class.any_instance.should_receive(:setup).with(@resource).once
      @task_class.new(@resource)
    end

    it "should set the callback params when passed as an argument" do
      @resource = @resource_class.new
      attributes = {:profile_field=>'introduction'}
      task = @task_class.new(@resource, attributes)
      task.attributes[:profile_field].should == 'introduction'
    end

    it "should symbolize the keys of the callback params when passed as an argument" do
      @resource = @resource_class.new
      attributes = {'profile_field'=>'introduction'}
      task = @task_class.new(@resource, attributes)
      task.attributes[:profile_field].should == 'introduction'
    end
  end

  describe ".attributes[]" do
    it "should allow callback params to be set" do
      task = Class.new { include SharedWorkforce::Task }.new(@resource_class.new, {})
      task.attributes[:profile_field] = 'introduction'
      task.attributes[:profile_field].should == 'introduction'
    end
  end

  describe "#request" do
    it "should make a new task http request" do
      task = Class.new { include SharedWorkforce::Task }

      stub_request(:post, "https://api.sharedworkforce.com/tasks")
      task.new.request(:request_id=>'123')
      a_request(:post, "https://api.sharedworkforce.com/tasks").should have_been_made.once
    end
  end
  
  describe "#cancel" do
    it "should send a cancel task http request" do
      task_class = Class.new { include SharedWorkforce::Task }

      stub_request(:post, "https://api.sharedworkforce.com/tasks/cancel")
      task_class.cancel(@resource_class.new)
      a_request(:post, "https://api.sharedworkforce.com/tasks/cancel").should have_been_made.once
    end

    it "should not raise a ConfigurationError if a callback host is not set" do
      task = Class.new { include SharedWorkforce::Task }
      with_configuration do |config|
        config.callback_host = nil
        config.api_key = "123456"
        lambda {
          task.new.cancel(:request_id=>'123')
        }.should_not raise_error SharedWorkforce::ConfigurationError
      end
    end
    
    it "should raise a ConfigurationError if an API key is not set" do
      task = Class.new { include SharedWorkforce::Task }
      with_configuration do |config|
        config.api_key = nil
        lambda {
          task.new.cancel(:request_id=>'123')
        }.should raise_error SharedWorkforce::ConfigurationError
      end
    end
  end

  describe "#resource" do
    it "should return the resource that passed to as an argument to new" do
      task_class = Class.new { include SharedWorkforce::Task }
      resource = @resource_class.new
      task = task_class.new(resource)
      task.resource.should == resource
    end

    it "should raise an ArgumentError if the resource does not respond to #find" do
      task_class = Class.new { include SharedWorkforce::Task }
      resource = double
      lambda {
        task = task_class.new(resource)
      }.should raise_error ArgumentError
    end

    it "should return the resource from the callback params" do
      class ResourceFinder; def self.find(id); return "#{id}ABCD"; end; end
      task_class = Class.new { include SharedWorkforce::Task }
      task = task_class.new(SharedWorkforce::TaskResult.new({'api_key'=>SharedWorkforce.configuration.api_key, 'task'=>{'callback_params'=>{'_task'=>{'resource'=>{'class_name'=>'ResourceFinder', 'id' => '2'}}}}}))
      task.resource.should == "2ABCD"
    end

    it "should return nil if the callback params do not specify a resource" do
      task_class = Class.new { include SharedWorkforce::Task }
      task = task_class.new(SharedWorkforce::TaskResult.new({'api_key'=>SharedWorkforce.configuration.api_key, 'task'=>{'callback_params'=>{}}}))
      task.resource.should == nil
    end
  end

  describe "#to_hash" do
    it "should include the class name and id of the resource in the callback params" do
      task_class = Class.new { include SharedWorkforce::Task }
      task = task_class.new(@resource_class.new)
      task.to_hash[:callback_params][:_task][:resource][:id].should == 333
      task.to_hash[:callback_params][:_task][:resource][:class_name].should == "Resource"
    end

    it "should include custom callback params in the callback params" do
      task_class = Class.new { include SharedWorkforce::Task }
      task = task_class.new(@resource_class.new, :profile_field=>'introduction')
      task.to_hash[:callback_params][:_task][:resource][:id].should == 333
      task.to_hash[:callback_params][:_task][:resource][:class_name].should == "Resource"
      task.to_hash[:callback_params][:profile_field].should == 'introduction'
    end

    it "should include the class name of the task" do
      task = ApprovePhotoTask.new(@resource_class.new, :profile_field=>'introduction')
      task.to_hash[:callback_params][:_task][:resource][:id].should == 333
      task.to_hash[:callback_params][:_task][:resource][:class_name].should == "Resource"
      task.to_hash[:callback_params][:_task][:class_name].should == 'ApprovePhotoTask'
    end

    it "should include the guidelines" do
      task = ApprovePhotoTask.new(@resource_class.new)
      task.guidelines = "* be careful"
      task.to_hash[:guidelines].should == '* be careful'
    end

    it "should include the image crop ratio" do
      task = ApprovePhotoTask.new(@resource_class.new)
      task.image_crop_ratio = 0.5
      task.to_hash[:image_crop_ratio].should == 0.5
    end

    it "should include the callback url" do
      with_configuration do |config|
        config.callback_host = 'http://callback.example.com'
        task = ApprovePhotoTask.new(@resource_class.new)
        task.image_crop_ratio = 0.5
        task.to_hash[:callback_url].should =~ %r{^http://callback.example.com/}
      end
    end

    it "should set a nil callback url" do
      with_configuration do |config|
        config.callback_host = 'http://callback.example.com'
        task = ApprovePhotoTask.new(@resource_class.new)
        task.image_crop_ratio = 0.5
        task.to_hash[:callback_url].should =~ %r{^http://callback.example.com/}
      end
    end
  end
end


