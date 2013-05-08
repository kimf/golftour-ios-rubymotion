class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NanoStore.shared_store = NanoStore.store(:file, App.documents_path + "/nano.db") # persist the data

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds, cornerRadius: 5, masksToBounds: true)

    @navigationController ||= UINavigationController.alloc.init
    @navigationController.pushViewController(ScorecardsListController.controller, animated:false)

    @window.rootViewController = @navigationController
    @window.makeKeyAndVisible

    @navigationController.navigationBar.tintColor = "#1b8ad4".to_color

    # to force login again: App::Persistence['authToken'] = nil
    if App::Persistence['authToken'].nil?
      show_welcome_screen
    end

    true
  end


  def server
    NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')
  end

  def auth_token
    App::Persistence['authToken'].nil? ? "" : App::Persistence['authToken']
  end

  def show_welcome_screen
    @welcomeController           ||= WelcomeController.alloc.init
    @welcomeNavigationController ||= UINavigationController.alloc.init
    @welcomeNavigationController.navigationBar.tintColor = "#1b8ad4".to_color
    @welcomeNavigationController.pushViewController(@welcomeController, animated:false)
    ScorecardsListController.controller.presentModalViewController(@welcomeNavigationController, animated:true)
  end
end