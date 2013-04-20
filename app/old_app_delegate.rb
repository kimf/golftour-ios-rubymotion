def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds, cornerRadius: 5, masksToBounds: true)

    customizeiPhoneTheme

    @tabBarController ||= configureiPhoneTabBar(UITabBarController.alloc.init)

    @navigationController ||= UINavigationController.alloc.initWithRootViewController(@tabBarController)

    @window.rootViewController = @navigationController

    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end


  def customizeiPhoneTheme


    navBarImage = UIImage.imageNamed('menubar.png')
    UINavigationBar.appearance.setBackgroundImage(navBarImage, forBarMetrics: UIBarMetricsDefault)

    barButton = UIImage.imageNamed('menubar-button.png', resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4))
    UIBarButtonItem.appearance.setBackgroundImage(barButton, forState: UIControlStateNormal, barMetrics: UIBarMetricsDefault)

    backButton = UIImage.imageNamed("back.png", resizableImageWithCapInsets: UIEdgeInsetsMake(0, 14, 0, 4))
    UIBarButtonItem.appearance.setBackgroundImage(backButton, forState: UIControlStateNormal, barMetrics: UIBarMetricsDefault)

  end

  def configureiPhoneTabBar(tabBarController)
    tabBarBackground = UIImage.imageNamed('tabbar.png')
    UITabBar.appearance.setBackgroundImage(tabBarBackground)
    UITabBar.appearance.setSelectionIndicatorImage(UIImage.imageNamed('tabbar-active.png'))

    news_feed_controller  = NewsFeedController.alloc.init
    players_controller    = PlayersController.alloc.init
    statistics_controller = StatisticsController.alloc.init
    play_controller       = PlayController.alloc.init

    news_feed_controller.tabBarItem   = configureTabBarItem("news.png", "Newsfeed")
    players_controller.tabBarItem     = configureTabBarItem("leaderboard.png", "Standings")
    statistics_controller.tabBarItem  = configureTabBarItem("stats.png", "Statistics")
    play_controller.tabBarItem        = configureTabBarItem("play.png", "Play")

    tabBarController.viewControllers = [
      news_feed_controller,
      players_controller,
      statistics_controller,
      play_controller
    ]
    tabBarController.selectedIndex = 0
    return tabBarController
  end

  def configureTabBarItem(imageName, itemText)
    item = UITabBarItem.alloc.initWithTitle(itemText, image:UIImage.imageNamed(imageName), tag:0)
    return item
  end