class PlayingController < UIViewController
  stylesheet :base
  attr_accessor :course, :players, :holes, :current_hole, :control

  layout do
    @course = Course.where(:id).eq(App::Persistence['current_course_id']).first
    self.title = @course.name

    @players = []
    App::Persistence['current_player_ids'].each do |id|
      @players << Player.where(:id).eq(id).first
    end

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

  def show_scorecard
    App.delegate.router.open("scorecard")
  end

end