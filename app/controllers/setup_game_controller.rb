class SetupGameController < UIViewController
  stylesheet :base
  attr_accessor :course, :selected_players

  layout :root do
    self.title = "Välj Spelare"

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAdd,
      target: self,
      action: :add_player)

    @players_table = UITableView.alloc.initWithFrame(view.frame, style: UITableViewStylePlain)
    @players_table.dataSource = self
    @players_table.delegate   = self
    #@players_table.setScrollEnabled(false)
    subview(@players_table, :players_table)

    subview(UIView, :button_bg) do
      @play_button = subview(UIButton, :play_button).on(:touch){ play }
    end
    @current_course_label = subview(UILabel, :current_course_label, text: @course.name)
  end

  def initWithCourse(course)
    init.tap do
      @course   = course
      @selected_players = [App.delegate.current_player]
      @players = Player.order(:name).all

      @reload_observer = App.notification_center.observe PlayerWasAddedNotification do |notification|
        @players << notification.object
        toggle_players(notification.object)
      end
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @players.count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      s  = @players[indexPath.row]
      cell.textLabel.text = "#{s.name}"
      if @selected_players.include?(s)
        cell.accessoryView = UIImageView.alloc.initWithImage(UIImage.imageNamed("checkbox.png"))
        cell.stylename = :selected
      else
        cell.accessoryView = nil
        cell.stylename = :default_cell
      end
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    toggle_players(@players[indexPath.row])
  end


  def toggle_players(player)
    @selected_players.include?(player) ? @selected_players.delete(player) : @selected_players << player
    toggle_buttons
    @players_table.reloadData
  end

  def toggle_buttons
    if @selected_players.length > 0
      @play_button.hidden = false
    else
      @play_button.hidden = true
    end
  end


  def add_player
    self.navigationController << NewPlayerController.alloc.init
  end

  def play
    scoringController = ScoringController.alloc.initWithRoundController(
      RoundController.alloc.initWithCourseAndPlayers(@course, @selected_players)
    )
    self.navigationController.presentModalViewController(scoringController, animated:true)
  end


  private
    def fresh_cell
      @players_table.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :default_cell do
          subview(UIView, :bottom_line)
        end
      end
    end

end