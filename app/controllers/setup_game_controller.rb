class SetupGameController < UIViewController
  stylesheet :base
  attr_accessor :course, :players

  layout :root do
    self.title = "Spela golf"

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemStop,
        target: self,
        action: :cancel)

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAdd,
      target: self,
      action: :add_player)

    @players_table = UITableView.alloc.initWithFrame(view.frame, style: UITableViewStylePlain)
    @players_table.dataSource = self
    @players_table.delegate   = self

    subview(@players_table, :players_table)

    @play_button = subview(UIButton, :play_button).on(:touch){ play }
    @play_button.hidden = true

    @change_course_button = subview(UIButton, :change_course_button).on(:touch){ select_course }

    @current_course_label = subview(UILabel, :current_course_label)

    select_course if @course.nil?
  end

  def select_course
    self.navigationController << CoursesController.alloc.init
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @players.count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      s  = @players[indexPath.row]
      cell.textLabel.text = "#{s.name}"
      cell.setSelectionStyle(UITableViewCellSelectionStyleNone)
    end
  end

  def layoutDidLoad
    super
    @players = []
    @course  = nil

    @reload_observer = App.notification_center.observe PlayerWasAddedNotification do |notification|
      @players << notification.object
      show_hide_buttons
      @players_table.reloadData
    end

    @course_observer = App.notification_center.observe CourseWasSelectedNotification do |notification|
      @course = notification.object
      @current_course_label.text = @course.name
      show_hide_buttons
    end
  end

  def show_hide_buttons
    if @players.length > 0 && !@course.nil?
      @play_button.hidden = false
    else
      @play_button.hidden = true
    end
  end


  def add_player
    self.navigationController << PlayersController.alloc.init
  end

  def play
    self.navigationController << RoundController.alloc.initWithCourseAndPlayers(@course, @players)
  end

  def cancel
    App.delegate.window.rootViewController.dismissModalViewControllerAnimated(true, completion:nil)
  end


  private
    def fresh_cell
      @players_table.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :default_cell do
          subview(UIView, :bottom_line)
        end
        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end

end
