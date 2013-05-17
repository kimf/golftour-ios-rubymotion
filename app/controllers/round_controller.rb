class RoundController < UIViewController
  stylesheet :base
  attr_accessor :course, :players, :holes, :current_hole, :control

  layout do
    self.title = self.course.name

    # @course.holes.each do |hole|
    #   subview(UIView, :hole, nr: hole.nr)
    #   #.on_swipe(:left){}
    #   #.on_swipe(:right){}
    # end

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemCompose,
        target: self,
        action: :show_scorecard)
  end

  def initWithCourseAndPlayers(course, players)
    init.tap do
      @course   = course
      @players  = players
    end
  end

  def show_scorecard
    self.navigationController << ScorecardController.alloc.init
  end

end