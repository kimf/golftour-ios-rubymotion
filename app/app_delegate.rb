class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NanoStore.shared_store ||= NanoStore.store(:file, App.documents_path + "/nano.db")

    @window ||= UIWindow.alloc.initWithFrame(
      UIScreen.mainScreen.bounds, cornerRadius: 5, masksToBounds: true
    )

    @navigationController ||= UINavigationController.alloc.initWithRootViewController(DashboardController.controller)
    @navigationController.navigationBar.tintColor = "#1b8ad4".to_color

    @window.rootViewController ||= @navigationController
    @window.makeKeyAndVisible

    @login = WelcomeController.alloc.init
    @login_navigation = UINavigationController.alloc.initWithRootViewController(@login)

    @login_navigation.navigationBar.tintColor = "#1b8ad4".to_color
    @login.title = "Simple Golftour"

    # if App::Persistence['authToken'].nil?
    #   DashboardController.controller.presentModalViewController(@login_navigation, animated:false)
    # end

    true
  end


  def server
    NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')
  end

  def auth_token
    "" #App::Persistence['authToken'].nil? ? "" : App::Persistence['authToken']
  end

  def is_authenticated
    true
    #App::Persistence['authToken'].nil? ? false : true
  end

  def applicationWillResignActive(application)
    # Sent when the application is about to move from active to inactive state. This can occur for certain types of
    # temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application
    # and it begins the transition to the background state. Use this method to pause ongoing tasks, disable timers, and
    # throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  end

  def applicationDidEnterBackground(application)
    # Use this method to release shared resources, save user data, invalidate timers, and store enough application
    # state information to restore your application to its current state in case it is terminated later.If your
    # application supports background execution, this method is called instead of applicationWillTerminate: when the
    # user quits.
  end

  def applicationWillEnterForeground(application)
    # Called as part of the transition from the background to the inactive state; here you can undo many of the
    # changes made on entering the background.
  end

  def applicationDidBecomeActive(application)
    # Restart any tasks that were paused (or not yet started) while the application was inactive. If the application
    # was previously in the background, optionally refresh the user interface.
  end

  def applicationWillTerminate(application)
    # Called when the application is about to terminate. Save data if appropriate. See also
    # applicationDidEnterBackground
  end
end

