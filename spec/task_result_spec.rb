require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskResult" do
  describe "#process!" do
    it "should invoke Task#process_result" do
      ApprovePhotoTask.any_instance.should_receive(:process_result).once
      SharedWorkforce::TaskResult.new({'callback_params'=>{'_task'=>{'class_name'=>'Approve photo'}, 'resource_id' => '2', 'responses'=>[{'answer'=>'yes'}], 'name'=>"Approve photo please"}}).process!
    end
  end
  
  describe "#responses" do
    it "should convert the result to a hash" do
      r = SharedWorkforce::TaskResult.new(
        {'callback_params'=>{'resource_id' => '2'},
         'responses'=>[
            {'answer'=>'yes', 'username'=>'bilbo'},
            {'answer'=>'no', 'username'=>'frodo'},
            {'answer'=>'yes', 'username'=>'sam'}
          ],
        'name'=>"Approve photo"
        }
      )

      r.responses.should == [
        {:answer=>'yes', :answered_by=>'bilbo'},
        {:answer=>'no', :answered_by=>'frodo'},
        {:answer=>'yes', :answered_by=>'sam'}
      ]
    end
  end
  
  describe "#usernames" do
    it "should collect the usernames" do  
      r = SharedWorkforce::TaskResult.new({'callback_params'=>{'resource_id' => '2'}, 'responses'=>[{'answer'=>'yes', 'username'=>'bilbo'}, {'answer'=>'no', 'username'=>'frodo'}, {'answer'=>'yes', 'username'=>'sam'}], 'name'=>"Approve photo"})
      r.usernames.should == ['bilbo', 'frodo', 'sam']
    end
  end

end