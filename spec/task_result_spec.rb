require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskResult" do

  before(:each) do
    @task_result_hash = {
      'task' => {  
        'name'=>"Approve photo please",
        'callback_params' => 
        {
          '_task'=>{'class_name'=>'ApprovePhotoTask'},
          'resource_id' => '2',
        },
        'responses' => [{'answer' => 'yes'}]
      }
    }
  end

  describe "#process!" do
    it "should invoke Task#process_result" do
      ApprovePhotoTask.any_instance.should_receive(:process_result).once
      SharedWorkforce::TaskResult.new(@task_result_hash).process!
    end
  end
  
  describe "#responses" do
    it "should convert the result to a hash" do
      r = SharedWorkforce::TaskResult.new(
        {'task' => 
          {
            'name'=>"Approve photo",
            'callback_params'=>{'resource_id' => '2'},
            'responses'=>[
              {'answer'=>'yes', 'username'=>'bilbo'},
              {'answer'=>'no', 'username'=>'frodo'},
              {'answer'=>'yes', 'username'=>'sam'}
            ]
          }
        }
      )

      r.responses.should == [
        {'answer'=>'yes', 'answered_by'=>'bilbo'},
        {'answer'=>'no', 'answered_by'=>'frodo'},
        {'answer'=>'yes', 'answered_by'=>'sam'}
      ]
    end
  end

  describe "#task_attributes" do
    it "should assign the task hash" do
      task = SharedWorkforce::TaskResult.new(@task_result_hash)
      task.task_hash.should == @task_result_hash['task']
    end

    it "should accept a task that is not nested in a :task key (backwards compatibility)" do
      task = SharedWorkforce::TaskResult.new(@task_result_hash['task'])
      task.task_hash.should == @task_result_hash['task']
    end
  end
  
  describe "#usernames" do
    it "should collect the usernames" do  
      r = SharedWorkforce::TaskResult.new({'callback_params'=>{'resource_id' => '2'}, 'responses'=>[{'answer'=>'yes', 'username'=>'bilbo'}, {'answer'=>'no', 'username'=>'frodo'}, {'answer'=>'yes', 'username'=>'sam'}], 'name'=>"Approve photo"})
      r.usernames.should == ['bilbo', 'frodo', 'sam']
    end
  end

end