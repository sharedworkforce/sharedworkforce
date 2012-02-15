require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskResult" do
  describe "#process!" do
    it "should invoke a tasks complete callback" do
      ApprovePhotoTask.should_receive(:complete!).once
      SharedWorkforce::TaskResult.new({'callback_params'=>{'resource_id' => '2'}, 'responses'=>[{'answer'=>'yes'}], 'name'=>"Approve photo"}).process!
    end

    it "should invoke a tasks success callback" do
      ApprovePhotoTask.should_receive(:complete!).once
      SharedWorkforce::TaskResult.new({'callback_params'=>{'resource_id' => '2'}, 'responses'=>[{'answer'=>'yes'}], 'name'=>"Approve photo"}).process!
    end
  end
  
  describe "#answers" do
    it "should collect the answers" do  
      r = SharedWorkforce::TaskResult.new({'callback_params'=>{'resource_id' => '2'}, 'responses'=>[{'answer'=>'yes'}, {'answer'=>'no'}, {'answer'=>'yes'}], 'name'=>"Approve photo"})
      r.answers.should == ['yes', 'no', 'yes']
    end
  end
  
  describe "#usernames" do
    it "should collect the usernames" do  
      r = SharedWorkforce::TaskResult.new({'callback_params'=>{'resource_id' => '2'}, 'responses'=>[{'answer'=>'yes', 'username'=>'bilbo'}, {'answer'=>'no', 'username'=>'frodo'}, {'answer'=>'yes', 'username'=>'sam'}], 'name'=>"Approve photo"})
      r.usernames.should == ['bilbo', 'frodo', 'sam']
    end
  end
end