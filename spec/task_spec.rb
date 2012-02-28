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
    task.answer_options.should == ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways']
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
  
  describe "#process_result" do
    it "should call success! and complete! with the results" do # Will become more important once we have task failure event handling
      task_class = Class.new { include SharedWorkforce::Task; on_success :do_work; def do_work(*args); end; def setup(*args); end }
      task = task_class.new
      task.should_receive(:success!)
      task.should_receive(:complete!)
      task.process_result(SharedWorkforce::TaskResult.new({}))
    end
  end
  
  describe "#success!" do
    it "should run a success callback" do
      task_class = Class.new { include SharedWorkforce::Task; on_success :do_work; def do_work(*args); end; def setup(*args); end }
      resource = @resource_class.new
      task = task_class.new(resource)
      task.should_receive(:do_work)
      task.success!(SharedWorkforce::TaskResult.new({}))
    end

    it "should pass the resource to the callback method as the first argument and the result as the second argument" do
      task_class = Class.new { include SharedWorkforce::Task; on_success :do_work; def do_work(*args); end; def setup(*args); end }
      resource = @resource_class.new
      result = SharedWorkforce::TaskResult.new({})
      task = task_class.new(resource)
      task.should_receive(:do_work).with(resource, result)
      task.success!(result)
    end
  end

  describe "#complete!" do
    it "should run a completion callback" do
      task_class = Class.new { include SharedWorkforce::Task; on_complete :it_finished; def it_finished(*args); end; def setup(*args); end }
      resource = @resource_class.new
      task = task_class.new(resource)
      task.should_receive(:it_finished)
      task.complete!(SharedWorkforce::TaskResult.new({}))
    end

    it "should pass the resource to the callback method as the first argument and the result as the second argument" do
      task_class = Class.new { include SharedWorkforce::Task; on_complete :it_finished; def it_finished(*args); end; def setup(*args); end }
      resource = @resource_class.new
      result = SharedWorkforce::TaskResult.new({})
      task = task_class.new(resource)
      task.should_receive(:it_finished).with(resource, result)
      task.complete!(result)
    end
  end

  describe "#fail!" do

    it "should run a failure callback" do
      task_class = Class.new { include SharedWorkforce::Task; on_failure :it_failed; def it_failed(*args); end; def setup(*args); end }
      resource = @resource_class.new
      task = task_class.new(resource)
      task.should_receive(:it_failed)
      task.fail!(SharedWorkforce::TaskResult.new({}))
    end

    it "should not raise an error if there is no callback defined" do
      lambda {
        task = Class.new { include SharedWorkforce::Task }
        task.new.fail!({})
      }.should_not raise_error
    end

    it "should pass the resource to the callback method as the first argument and the result as the second argument" do
      task_class = Class.new { include SharedWorkforce::Task; on_failure :it_failed; def it_failed(*args); end; def setup(*args); end }
      resource = @resource_class.new
      result = SharedWorkforce::TaskResult.new({})
      task = task_class.new(resource)
      task.should_receive(:it_failed).with(resource, result)
      task.fail!(result)
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
      callback_params = {:profile_field=>'introduction'}
      task = @task_class.new(@resource, callback_params)
      task.callback_params[:profile_field].should == 'introduction'
    end

    it "should symbolize the keys of the callback params when passed as an argument" do
      @resource = @resource_class.new
      callback_params = {'profile_field'=>'introduction'}
      task = @task_class.new(@resource, callback_params)
      task.callback_params[:profile_field].should == 'introduction'
    end
  end

  describe ".callback_params[]" do
    it "should allow callback params to be set" do
      task = Class.new { include SharedWorkforce::Task }.new(@resource_class.new, {})
      task.callback_params[:profile_field] = 'introduction'
      task.callback_params[:profile_field].should == 'introduction'
    end
  end

  describe "#request" do
    it "should make a new task http request" do
      task = Class.new { include SharedWorkforce::Task }

      stub_request(:post, "http://api.sharedworkforce.com/tasks")
      task.new.request(:request_id=>'123')
      a_request(:post, "http://api.sharedworkforce.com/tasks").should have_been_made.once
    end
  end
  
  describe "#cancel" do
    it "should send a cancel task http request" do
      task = Class.new { include SharedWorkforce::Task }

      stub_request(:post, "http://api.sharedworkforce.com/tasks/cancel")
      task.new.cancel(:request_id=>'123')
      a_request(:post, "http://api.sharedworkforce.com/tasks/cancel").should have_been_made.once
    end

    it "should raise a ConfigurationError if a callback host is not set" do
      task = Class.new { include SharedWorkforce::Task }
      with_configuration do |config|
        config.callback_host = nil
        lambda {
          task.new.cancel(:request_id=>'123')
        }.should raise_error SharedWorkforce::ConfigurationError
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
      task = task_class.new(SharedWorkforce::TaskResult.new({'callback_params'=>{'resource_class_name'=>'ResourceFinder', 'resource_id' => '2'}}))
      task.resource.should == "2ABCD"
    end

    it "should return nil if the callback params do not specify a resource" do
      task_class = Class.new { include SharedWorkforce::Task }
      task = task_class.new(SharedWorkforce::TaskResult.new({'callback_params'=>{}}))
      task.resource.should == nil
    end
  end

  describe "#to_hash" do
    it "should include the class name and id of the resource in the callback params" do
      task_class = Class.new { include SharedWorkforce::Task }
      task = task_class.new(@resource_class.new)
      task.to_hash[:callback_params][:resource_id].should == 333
      task.to_hash[:callback_params][:resource_class_name].should == "Resource"
    end

    it "should include custom callback params in the callback params" do
      task_class = Class.new { include SharedWorkforce::Task }
      task = task_class.new(@resource_class.new, :profile_field=>'introduction')
      task.to_hash[:callback_params][:resource_id].should == 333
      task.to_hash[:callback_params][:resource_class_name].should == "Resource"
      task.to_hash[:callback_params][:profile_field].should == 'introduction'
    end
  end
end


