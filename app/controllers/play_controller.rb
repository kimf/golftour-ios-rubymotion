class PlayController < UITableViewController
  stylesheet :table
  attr_accessor :course_id, :course, :players, :selected_players, :play_button

  def self.controller
    @controller ||= PlayController.alloc.initWithNibName(nil, bundle: nil)
  end

  layout :table do
    @course = Course.find(:id, NSFEqualTo, self.course_id).first
    self.title = "Välj spelare"

    newButton = UIBarButtonItem.alloc.initWithTitle("+ NY", style: UIBarButtonItemStylePlain, target:self, action:'new')
    self.navigationItem.rightBarButtonItem = newButton

    @play_button = subview(UIButton, :play_button)
    @play_button.when_tapped do
      play
    end
  end


  def reload_players
    @players = Player.all({:sort => {:name => :desc}})
    self.tableView.reloadData
  end

  def init
    super
    reload_players
  end

  def viewDidLoad
    super
    reload_players
    @selected_players = []
    layout tableView, :table
    tableView.rowHeight = 40
    self.tableView.reloadData
  end

  def new
    controller = NewPlayerController.new
    navigationController = UINavigationController.alloc.initWithRootViewController(controller)
    navigationController.navigationBar.tintColor = "#1b8ad4".to_color
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical
    self.presentViewController(navigationController, animated: true, completion: lambda{})
  end


  def play
    controller = PlayingController.alloc.init
    controller.course = @course
    controller.players = @selected_players
    navigationController = UINavigationController.alloc.initWithRootViewController(controller)
    navigationController.navigationBar.tintColor = "#1b8ad4".to_color
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal
    self.presentViewController(navigationController, animated: true, completion: lambda{})
  end


  def tableView(tableView, numberOfRowsInSection:section)
    @players.count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      s = @players[indexPath.row]
      cell.textLabel.text = "#{s.name}"
      cell.accessoryType  = UITableViewCellAccessoryNone

      if @selected_players.include?(s)
        cell.accessoryType = UITableViewCellAccessoryCheckmark
      end
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    toggle_player(@players[indexPath.row])
    if @selected_players.length > 0
      @play_button.hidden = false
    else
      @play_button.hidden = true
    end
  end

  def toggle_player(player)
    if !@selected_players.include?(player)
      return false if @selected_players.length == 4
      @selected_players << player
    else
      @selected_players.delete(player)
    end
    self.tableView.reloadData
  end

  private
    def fresh_cell
      tableView.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :cell do
          subview(UIView, :top_line)
          subview(UIView, :bottom_line)
        end

        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end
end