describe Scorecard do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers

  it "should extract attributes" do
    account = Scorecard.new(:id => 1, :course => 'Dal', :strokes => 95)
    account.id.should == 1
    account.course.should == 'Dal'
    account.strokes.should == 95
  end
end
