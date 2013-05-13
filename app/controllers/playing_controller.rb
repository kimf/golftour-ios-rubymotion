class PlayingController < UIViewController
  stylesheet :base
  attr_accessor :course, :players, :holes, :current_hole, :control

  layout :root do
    @course = Course.find(:id, NSFEqualTo, App::Persistence['current_course_id']).first
    self.title = @course.name

    @players = []
    App::Persistence['current_player_ids'].each do |id|
      @players << Player.find(:id, NSFEqualTo, id)
    end

    @holes = Hole.find(:course_id, NSFEqualTo, @course.id)
    # @holes.each do |hole|
    #   subview(UIView, :hole, nr: hole.nr)
    #   #.on_swipe(:left){}
    #   #.on_swipe(:right){}
    # end

    @horizontal_page_scroller = subview(UIScrollView, :horizontal_page_scroller)

    showScorecardButton = UIBarButtonItem.alloc.initWithTitle("i", style: UIBarButtonItemStylePlain, target:self, action:'show_scorecard')
    self.navigationItem.rightBarButtonItem = showScorecardButton
  end

  def layoutDidLoad
    @horizontal_page_scroller.contentSize = CGSizeMake(320 * (@holes.count + 2), 520)
    @horizontal_page_scroller.pagingEnabled = true

    @slides = []
    @holes.each do |hole|
      slide = UIView.new

      if @slides.count > 0
        slide.frame = @slides.last.frame = [[320,320], [320,520]]
      else
        slide.frame = [[320,0], [320,520]]
      end

      @slides << slide
      @horizontal_page_scroller.addSubview(@slides.last)
    end
  end

  def show_scorecard
    App.delegate.router.open("scorecard")
  end

end