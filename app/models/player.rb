class Player < MotionMigrate::Model
  property :name, :string
  property :email, :string
  property :api_token, :string

  has_many :scorecards, :class_name => "Scorecard", :inverse_of => :player
end
