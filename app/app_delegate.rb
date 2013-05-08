class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds, cornerRadius: 5, masksToBounds: true)

    @navigationController ||= UINavigationController.alloc.init
    @navigationController.pushViewController(ScorecardsListController.controller,
                                              animated:false)

    @window.rootViewController = @navigationController
    @window.makeKeyAndVisible

    # to force login again: App::Persistence['authToken'] = nil

    if App::Persistence['authToken'].nil?
      show_welcome_screen
    end

    true
  end


  def show_welcome_screen
    @welcomeController           ||= WelcomeController.alloc.init
    @welcomeNavigationController ||= UINavigationController.alloc.init

    @welcomeNavigationController.pushViewController(@welcomeController, animated:false)


    ScorecardsListController.controller.presentModalViewController(@welcomeNavigationController,
                                                                    animated:true)
  end
end