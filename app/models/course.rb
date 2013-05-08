class Course < NanoStore::Model
  attribute :id
  attribute :name
  attribute :par

  bag :holes
end