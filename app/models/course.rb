class Course < NanoStore::Model
  attribute :id
  attribute :name
  attribute :par
  attribute :index
  attribute :has_gps
  attribute :holes_count
  attribute :lat
  attribute :lng
end