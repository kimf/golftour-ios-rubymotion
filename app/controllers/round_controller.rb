class RoundController < UIViewController
  stylesheet :base
  attr_accessor :course, :players, :holes, :current_hole, :control

  layout :root do
    self.title = self.course.name

    # @course.holes.each do |hole|
    #   subview(UIView, :hole, nr: hole.nr)
    #   #.on_swipe(:left){}
    #   #.on_swipe(:right){}
    # end

    @current_hole_label = subview(UILabel, :current_hole_label, text: hole_label_text(@current_hole))

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
      "=",
      style: UIBarButtonItemStyleBordered,
      target: viewDeckController,
      action: 'toggleLeftView'
    )

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemCompose,
        target: self,
        action: :show_scorecard)
  end

  def initWithCourseAndPlayers(course, players)
    init.tap do
      @course   = course
      @players  = players
      @current_hole = course.holes.where(:nr).eq(1).first
    end
  end

  def change_hole(hole)
    @current_hole = hole
    @current_hole_label.text = hole_label_text(hole)
  end

  def hole_label_text(hole)
    "Hål #{hole.nr} par: #{hole.par}, #{hole.length}m"
  end

  def show_scorecard
    self.navigationController << ScorecardController.alloc.init
  end

end