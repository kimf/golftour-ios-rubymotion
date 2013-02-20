class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    Golftour.server = NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')

    @window.rootViewController = UINavigationController.alloc.initWithRootViewController ScorecardsViewController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end