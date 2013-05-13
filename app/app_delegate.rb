class AppDelegate
  attr_reader :window, :router, :store

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    #SETUP DB
    @store = NanoStore.shared_store ||= NanoStore.store(:file, App.documents_path + "/nano.db")

    #SETUP AFMOTION NETWORK CLIENT
    AFNetworkActivityIndicatorManager.sharedManager.enabled=true
    AFMotion::Client.build_shared(NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')) do
      header "Accept", "application/json"
      operation :json
    end

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    map_urls

    # .open(url, animated)
    if self.is_authenticated?
      @router.open("leaderboard", false)
    else
      @router.open("login", false)
    end
    true
  end

  def map_urls
    @router = Routable::Router.router
    @router.navigation_controller = UINavigationController.alloc.init

    # :modal means we push it modally.
    @router.map("login", LoginController, modal: true)
    @router.map("register", RegisterController, shared: true)

    # :shared means it will only keep one instance of this VC in the hierarchy;
    # if we push it again later, it will pop any covering VCs.
    @router.map("leaderboard", LeaderboardController, shared: true)

    @router.map("courses", CoursesController, shared: true)
    @router.map("new_course", NewCourseController, modal: true)

    @router.map("players", PlayersController)
    @router.map("new_player", NewPlayerController, modal: true)

    @router.map("playing", PlayingController, resets: true)
    @router.map("scorecard", ScorecardController, modal: true)

    @router.map("back_to_leaderboard", LeaderboardController, resets: true)


    # can also route arbitrary blocks of code
    @router.map("logout") do
      App::Persistence['authToken'] = nil
      @router.open("login")
    end

    @window.rootViewController = @router.navigation_controller
  end

  def auth_token
    "" #App::Persistence['authToken'].nil? ? "" : App::Persistence['authToken']
  end

  def is_authenticated?
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

