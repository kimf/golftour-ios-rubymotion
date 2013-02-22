class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    if RUBYMOTION_ENV == 'test'
      MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("GolftourTest.sqlite")
      #return true
    else
      MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("Golftour.sqlite")
    end

    #Golftour.server = NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')

    initialize_data

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = ScorecardsViewController.alloc.init
    @window.makeKeyAndVisible
    true
  end

  def initialize_data
    MagicalRecord.saveUsingCurrentThreadContextWithBlockAndWait(lambda do |local_context|
      Player.MR_truncateAll
      Scorecard.MR_truncateAll

      buck = Player.MR_createInContext(local_context)
      buck.name = "Buck Danny"

      x = Scorecard.MR_createInContext(local_context)
      x.course = "Los Arqueros"
      x.strokes = "72"
      x.time_of_day = "morning"
      x.date = "2012-02-12"

      y = Scorecard.MR_createInContext(local_context)
      y.course = "Los Arqueros"
      y.strokes = "74"
      y.time_of_day = "evening"
      y.date = "2012-02-10"

      buck.addScorecardsObject x
      buck.addScorecardsObject y
      NSManagedObjectContext.contextForCurrentThread.MR_saveToPersistentStoreAndWait
    end)
  end
end
