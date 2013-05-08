class Scorecard < NanoStore::Model
  attribute :id
  attribute :course
  attribute :par
  attribute :strokes
  attribute :played_at
  attribute :created_at
  attribute :updated_at

  class << self
    def create_new id, course ,par, strokes, played_at
     obj =  new(
                id: id,
                course: course,
                par: par,
                strokes: strokes,
                played_at: played_at,
                updated_at: Time.now,
                created_at: Time.now)
     obj.save
    end
  end
end