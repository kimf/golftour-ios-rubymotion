class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NanoStore.shared_store = NanoStore.store(:file, App.documents_path + "/nano.db") # persist the data

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds, cornerRadius: 5, masksToBounds: true)

    @navigationController ||= UINavigationController.alloc.init
    @navigationController.navigationBar.tintColor = "#1b8ad4".to_color

    @window.rootViewController = @navigationController
    @window.makeKeyAndVisible

    # to force login again: App::Persistence['authToken'] = nil
    # if App::Persistence['authToken'].nil?
    #   @navigationController.pushViewController(WelcomeController.new, animated:true)
    # else
      @navigationController.pushViewController(ScorecardsListController.new, animated:true)
    # end

    true
  end


  def server
    NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')
  end

  def auth_token
    App::Persistence['authToken'].nil? ? "" : App::Persistence['authToken']
  end
end