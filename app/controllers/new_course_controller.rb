class NewCourseController < UIViewController
  stylesheet :base
  attr_accessor :course, :name

  def teacup_layout
    self.title = "New Course"
  end

  # def save
  # @task = Task.new :name => 'walk the dog',
  #              :description => 'get plenty of exercise. pick up the poop',
  #              :due_date => '2012-09-15'

  # show_scary_warning unless @task.valid?
  #   navigationController.dismissViewControllerAnimated(true, completion: lambda{})
  # end
end