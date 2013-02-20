class Scorecard < MotionResource::Base
  attr_accessor :id, :date, :time_of_day, :course, :strokes

  # has_many :scores

  self.collection_url = "scorecards"
  self.member_url = "scorecards/:id"
end
