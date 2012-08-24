class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # UIScreen describes the display our app is running on
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    @blue_view = UIView.alloc.initWithFrame(CGRectMake(10, 10, 100, 100))
    @blue_view.backgroundColor = UIColor.blueColor
    @window.addSubview(@blue_view)

    true
  end
end
