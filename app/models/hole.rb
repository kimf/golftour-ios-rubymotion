class Hole
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns :nr         => :integer,
          :par        => :integer,
          :meters     => :integer,
          :hcp        => :integer,
          :lat        => :string,
          :lng        => :string

  belongs_to :course
end