class Player < MotionResource::Base
  attr_accessor :name, :email

  self.member_url = "players/:id"

  cattr_accessor :current

  has_many :scorecards
end
