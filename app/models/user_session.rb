class UserSession < MotionResource::Base
  attribute :email, :password

  self.collection_url = "players/login"

  def login(&block)
    self.class.post(collection_url, :payload => { :user_session => attributes }, &block)
  end
end
