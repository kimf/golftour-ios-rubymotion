describe Player do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers

  it "should extract attributes" do
    account = Player.new(:name => "Kim", :email => "kim@kim.se", :api_token => "12345678")
    account.name.should == "Kim"
    account.email.should == 'kim@kim.se'
    account.api_token.should == "12345678"
  end
end
