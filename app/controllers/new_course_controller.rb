class NewCourseController < UIViewController
  stylesheet :base
  attr_accessor :course, :name

  layout :root do
    self.title = "New Course"
    closeButton = UIBarButtonItem.alloc.initWithTitle("Close", style: UIBarButtonItemStylePlain, target:self, action:'close')
    self.navigationItem.leftBarButtonItem = closeButton
  end

  def close
    navigationController.dismissViewControllerAnimated(true, completion: lambda{})
  end

  # def save
  # @task = Task.new :name => 'walk the dog',
  #              :description => 'get plenty of exercise. pick up the poop',
  #              :due_date => '2012-09-15'

  # show_scary_warning unless @task.valid?
  #   navigationController.dismissViewControllerAnimated(true, completion: lambda{})
  # end
end