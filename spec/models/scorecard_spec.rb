describe Scorecard do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers

  it "should extract attributes" do
    account = Scorecard.new(:id => 1, :course => 'Dal', :strokes => 95)
    account.id.should == 1
    account.course.should == 'Dal'
    account.strokes.should == 95
  end

  it "should have trivial collection URL" do
    Scorecard.new.collection_url.should == "scorecards"
  end

  it "should have the ID in the member URL" do
    Scorecard.new(:id => 10).member_url.should == "scorecards/10"
  end
end
