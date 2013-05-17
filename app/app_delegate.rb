PlayerWasAddedNotification    = "PlayerWasAddedNotification"
CourseWasSelectedNotification = "CourseWasSelectedNotification"

class AppDelegate
  attr_accessor :window, :deckController, :centerController, :leftController

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    #SETUP AFMOTION NETWORK CLIENT
    AFNetworkActivityIndicatorManager.sharedManager.enabled=true
    AFMotion::Client.build_shared(NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')) do
      header "Accept", "application/json"
      operation :json
    end

    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    if self.is_authenticated?
      self.window.rootViewController = self.deckController
    else
      self.window.rootViewController = LoginController.alloc.init
    end
    self.window.makeKeyAndVisible
    true
  end

  def auth_token
    App::Persistence['authToken'].nil? ? "" : App::Persistence['authToken']
  end

  def is_authenticated?
    App::Persistence['authToken'].nil? ? false : true
  end

  def logout
    UIActionSheet.alert 'Vill du verkligen logga ut?', buttons: ['Näää', 'Japp!'],
      cancel: proc { },
      destructive: proc {
        App::Persistence['authToken'] = nil
        self.window.rootViewController = LoginController.alloc.init
      }
  end


  def login(auth_token, current_player_id)
    App::Persistence['current_player_id'] = current_player_id
    App::Persistence['authToken']         = auth_token
    self.window.rootViewController        = deckController
  end

  def deckController
    self.leftController   ||= MenuController.alloc.init
    self.centerController ||= UINavigationController.alloc.initWithRootViewController(LeaderboardController.alloc.init)

    self.centerController.navigationBar.tintColor = "#1b8ad4".to_color

    deckController        ||= IIViewDeckController.alloc.initWithCenterViewController(
                              self.centerController,
                              leftViewController: self.leftController
                        )
    deckController.rightSize = 100

    return deckController
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

