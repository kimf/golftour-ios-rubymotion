class Hole
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns :nr         => :integer,
          :par        => :integer,
          :length     => :integer,
          :hcp        => :integer,
          :lat        => :string,
          :lng        => :string

  belongs_to :course
end