class Player
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns :name           => :string,
          :points         => :integer,
          :rounds         => :integer,
          :average_points => :float,
          :email          => :string,
          :hcp            => :float
end