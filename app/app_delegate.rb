PlayerWasAddedNotification    = "PlayerWasAddedNotification"
CourseWasSelectedNotification = "CourseWasSelectedNotification"

class AppDelegate
  attr_accessor :window, :deckController, :centerController, :leftController

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    #SETUP AFMOTION NETWORK CLIENT
    AFNetworkActivityIndicatorManager.sharedManager.enabled=true
    AFMotion::Client.build_shared(NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')) do
      header "Accept", "application/json"
      response_serializer :json
    end

    #READ DATA FROM FILES
    Player.deserialize_from_file('players.dat')
    Course.deserialize_from_file('courses.dat')
    Hole.deserialize_from_file('holes.dat')

    appearance_defaults

    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    self.window.rootViewController = deckController #self.is_authenticated? ? deckController : LoginController.new

    self.window.makeKeyAndVisible
    true
  end

  def current_player
    return nil if App::Persistence['current_player_id'].nil?
    Player.where(:id).eq(App::Persistence['current_player_id']).first
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
        @deckController.closeLeftView
        @window.rootViewController = LoginController.alloc.init
      }
  end

  def login(auth_token, current_player_id)
    App::Persistence['current_player_id'] = current_player_id
    App::Persistence['authToken']         = auth_token
    @window.rootViewController            = deckController
  end

  def deckController
    @leftController   ||= MenuController.alloc.init
    @centerController ||= UINavigationController.alloc.initWithRootViewController(LeaderboardController.alloc.init)

    @deckController        ||= IIViewDeckController.alloc.initWithCenterViewController(
                              @centerController,
                              leftViewController: @leftController
                        )
    @deckController.rightSize = 100

    return @deckController
    # ScoringController.alloc.initWithRoundController(
    #   RoundController.alloc.initWithCourseAndPlayers(Course.first, Player.all[0..4])
    # )
  end


  def appearance_defaults
    #UIApplication.sharedApplication.setStatusBarHidden true, animated:false
    #UITabBar.appearance.tintColor = "#123456".to_color
    #UITabBar.appearance.selectionIndicatorImage = UIImage.imageNamed("someimage.png")
    UINavigationBar.appearance.tintColor = "#447ca5".to_color
    UISearchBar.appearance.tintColor = "#447ca5".to_color
    UIPageControl.appearance.backgroundColor = "#447ca5".to_color
    #UIToolbar.appearance.tintColor = "#1b8ad4".to_color
  end

end
