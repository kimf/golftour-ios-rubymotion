class ScorecardViewController < UIViewController
  attr_accessor :scorecard

  # # # # # # # # #
  #
  # UI and table stuff
  #
  # # # # # # # # #
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor

    course_label = UILabel.alloc.initWithFrame([[10, 10], [300, 20]])
    course_label.text = "#{scorecard.course}"
    course_label.textAlignment = NSTextAlignmentCenter
    self.view.addSubview(course_label)
  end

  def viewWillAppear( animated )
    super
    navigationController.setNavigationBarHidden(true, animated: true)
    UIApplication.sharedApplication.statusBarOrientation = UIDeviceOrientationLandscapeLeft
  end
end