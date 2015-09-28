class ScorecardController < UIViewController
  stylesheet :base

  attr_accessor :course, :players, :holes, :scores


  # LAYOUT
  # ------------------------------------------------------------------------------------------
  layout :scorecard

  def teacup_layout
    subview(UIView, :navigation_bar) do
      subview(UILabel, :hole_label, text: @course.name)
      subview(UIButton, :end_round_button).on_tap do
        cancel_scorecard
      end
      subview(UIButton, :scorecard_button).on_tap do
        hide_scorecard
      end
    end


    subview(UILabel, :hole_nr_header_label, text: 'Hål')
    left = 35
    @holes.each do |hole|
      left += 25
      subview(UILabel, :hole_nr_label, text: "#{hole.nr}", left: left)
      if hole.nr == 9
        left += 25
        subview(UILabel, :hole_nr_label, text: "UT", left: left)
      end
      if hole.nr == 18
        left += 25
        subview(UILabel, :hole_nr_label, text: "IN", left: left)
      end
    end
    subview(UILabel, :hole_nr_label, text: "TOT", left: left+25)



    subview(UILabel, :par_header_label, text: 'Par')
    left = 35
    @holes.each do |hole|
      left += 25
      subview(UILabel, :par_label, text: "#{hole.par}", left: left)
      if hole.nr == 9
        left += 25
        subview(UILabel, :par_label, text: "#{@holes[0..8].inject(0){ |sum,x| sum+x.par }}", left: left)
      end
      if hole.nr == 18
        left += 25
        subview(UILabel, :par_label, text: "#{@holes[9..17].inject(0){ |sum,x| sum+x.par }}", left: left)
      end
    end
    subview(UILabel, :par_label, text: "#{@course.par}", left: left+25)

    top = 104
    @scores.each do |score|
      subview(UILabel, :score_header_label, text: score[:player][:name].split(' ').first, top: top)
      left = 35
      score[:holes].each do |hole|
        left += 25
        subview(UILabel, :score_label, text: "#{hole[:strokes]}", left: left, top: top)
        if hole[:hole] == 9
          left += 25
          subview(UILabel, :score_label, text: "#{strokes_for_player(score[:player][:id], [1..9])}", left: left, top: top)
        end
        if hole[:hole] == 18
          left += 25
          subview(UILabel, :score_label, text: "#{strokes_for_player(score[:player][:id], [10..18])}", left: left, top: top)
        end
      end
      subview(UILabel, :score_label, text: "#{strokes_for_player(score[:player][:id], [1..18])}", left: left+25, top: top)
      top += 44
    end




    # @scorecard_table = UITableView.alloc.initWithFrame(view.frame, style: UITableViewStylePlain)
    # @scorecard_table.dataSource = self
    # @scorecard_table.delegate   = self
    # @scorecard_table.setScrollEnabled(false)
    # @scorecard_table.setRowHeight(30)
    # subview(@scorecard_table, :scorecard_table)
  end

  # INITIALIZION
  # ------------------------------------------------------------------------------------------
  def initWithData(course, players)
    init.tap do
      @course   = course
      @players  = players
      @holes    = course.holes.all
      init_scores(@holes, @players)
    end
  end

  def init_scores(holes, players)
    @scores = []
    @players.each do |player|
      score = {player: {id: player.id, name: player.name}, holes: []}
      @holes.each do |hole|
        score[:holes] << {hole: hole.nr, strokes: 0, points: 0}
      end
      @scores << score
    end
    @scores
  end

  # # SCORECARD TABLE
  # # ------------------------------------------------------------------------------------------
  # def tableView(tableView, numberOfRowsInSection:section)
  #   @scores.count || 0
  # end

  # def tableView(tableView, cellForRowAtIndexPath:indexPath)
  #   fresh_cell.tap do |cell|
  #     s = @scores[indexPath.row]
  #     layout(cell.contentView) do
  #       subview(UILabel, :scorecard_name_label, text: "#{s[:player][:name].split(" ").first}")
  #       subview(UIView, :bottom_line)
  #       cell.setSelectionStyle(UITableViewCellSelectionStyleNone)
  #     end
  #   end
  # end

  # HELPER METHODS
  # ------------------------------------------------------------------------------------------
  def strokes_for_player(player_id, holes=[])
    find_holes(player_id, holes).inject(0){ |sum,x| sum+x[:strokes] }
  end

  def points_for_player(player_id, holes=[])
    find_holes(player_id, holes).inject(0){ |sum,x| sum+x[:points] }
  end

  def find_holes(player_id, holes)
    find_score(player_id)[:holes].select{|h| holes.include?(h[:hole])}
  end

  def find_score(player_id)
    @scores.select{|s| s[:player][:id] == player_id }.first
  end


  # ACTIONS
  # ------------------------------------------------------------------------------------------
  def cancel_scorecard
    UIActionSheet.alert 'Vill du verkligen avbryta rundan?', buttons: ['Näää', 'Ja jag är trött!'],
      cancel: proc { },
      destructive: proc {
        App.delegate.window.rootViewController.dismissModalViewControllerAnimated(true, completion:nil)
      }
  end

  def hide_scorecard
    self.dismissModalViewControllerAnimated(true, completion:nil)
  end


  # PRIVATE METHODS
  # ------------------------------------------------------------------------------------------
  private
    def fresh_cell
      @scorecard_table.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'Cell')
    end
end