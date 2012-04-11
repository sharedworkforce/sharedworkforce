require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskResponse" do
  describe ".create_collection_from_array" do
    it "should create responses from an array" do
      r = SharedWorkforce::TaskResponse.create_collection_from_array([{'answer'=>'answer 1'}, {'answer'=>'answer 2'}])
      r[0].answer.should == "answer 1"
      r[1].answer.should == "answer 2"
    end
  
    it "should accept and store a username" do
      r = SharedWorkforce::TaskResponse.create_collection_from_array([{'answer'=>'answer 1', 'username'=>'bilbo'}, {'answer'=>'answer 2', 'username'=>'frodo'}])
      r[0].username.should == "bilbo"
      r[1].username.should == "frodo"
    end
  end

  describe "#to_hash" do
    it "should include answered_by" do
      t = SharedWorkforce::TaskResponse.new('username'=>'bilbo')
      t.to_hash[:answered_by].should == 'bilbo'
    end
    it "should include new_image_url" do
      t = SharedWorkforce::TaskResponse.new('new_image_url'=>'http://www.example.com/image.jpg')
      t.to_hash[:new_image_url].should == 'http://www.example.com/image.jpg'
    end
  end
end
