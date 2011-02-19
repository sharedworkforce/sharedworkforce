require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HitResponse" do
  it "should create responses from an array" do
    r = Hci::HitResponse.create_collection_from_array([{:answer=>'answer 1'}, {:answer=>'answer 2'}])
    r[0].answer.should == "answer 1"
    r[1].answer.should == "answer 2"
  end
end
