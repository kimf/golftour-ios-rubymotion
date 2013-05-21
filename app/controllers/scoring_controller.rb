class ScoringController < UIViewController
  attr_accessor :pageViewController,
                :roundController

  def viewDidLoad
    super
    @pageViewController = UIPageViewController.alloc.initWithTransitionStyle(
      UIPageViewControllerTransitionStyleScroll, navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal, options:nil )

    @pageViewController.delegate = self


    startingViewController = @roundController.viewControllerAtIndex(0)
    viewControllers = [startingViewController]
    @pageViewController.setViewControllers(viewControllers, direction:UIPageViewControllerNavigationDirectionForward,
                                           animated:false, completion:lambda{|a|}) # completion:nil blows up!
    @pageViewController.dataSource = @roundController

    addChildViewController(@pageViewController)
    view.addSubview(@pageViewController.view)

    @pageViewController.view.frame = view.bounds

    # Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    view.gestureRecognizers = @pageViewController.gestureRecognizers
  end

  def initWithRoundController(roundController)
    init.tap do
      @roundController = roundController
    end
  end
end