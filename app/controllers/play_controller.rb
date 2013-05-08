class PlayController < UIViewController
  stylesheet :base
  attr_accessor :course_id, :course

  layout :root do
    self.course = Course.find(:id, NSFEqualTo, self.course_id).first
    self.title = self.course.name
  end

  # def viewWillAppear( animated )
  #   super
  #   navigationController.setNavigationBarHidden(false, animated: true)
  # end
end