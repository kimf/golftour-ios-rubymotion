class RoundController < UIViewController
  stylesheet :base

  attr_accessor :course,
                :players,
                :scorecardController,
                :holes

  def initWithCourseAndPlayers(course, players)
    init.tap do
      @course   = course
      @players  = players
      @holes = @course.holes.all
      @scorecardController ||= ScorecardController.alloc.initWithData(@course, @players)
    end
  end

  #PAGING
  def viewControllerAtIndex(index)
    return nil if @holes.length==0 || index >= @holes.length
    HoleScoreController.alloc.initWithData(@holes[index], @players, @scorecardController)
  end

  def indexOfViewController(viewController)
    viewController.current_hole.nr - 1
  end

  def pageViewController(pvc, viewControllerBeforeViewController: vc)
    index = indexOfViewController(vc)
    return nil if index == 0
    index -= 1
    viewControllerAtIndex(index)
  end


  def pageViewController(pvc, viewControllerAfterViewController:vc)
    index = indexOfViewController(vc)
    index += 1
    return nil if index==@holes.length
    viewControllerAtIndex(index)
  end


  def presentationCountForPageViewController(vc)
    @holes.count
  end

  def presentationIndexForPageViewController(vc)
    0
  end
end