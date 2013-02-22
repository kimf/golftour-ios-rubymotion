class Scorecard < MotionMigrate::Model
  property :date, :string
  property :time_of_day, :string
  property :course, :string
  property :strokes, :string

  belongs_to :player, :class_name => "Player",  :inverse_of => :scorecards
end