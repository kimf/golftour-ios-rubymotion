class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'
    Golftour.server = NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = MonitorNavigationController.alloc.init
    @window.makeKeyAndVisible
    true
  end
end
