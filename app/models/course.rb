class Course
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns :name         => :string,
          :par          => :integer,
          :index        => :integer,
          :has_gps      => :boolean,
          :holes_count  => :integer,
          :lat          => :string,
          :lng          => :string

  has_many :holes, :dependent => :destroy
end