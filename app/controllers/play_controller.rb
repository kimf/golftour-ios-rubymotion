class PlayController < UITableViewController
  stylesheet :scorecards_sheet
  attr_accessor :course_id, :course, :players, :selected_players

  layout :table do
    self.course = Course.find(:id, NSFEqualTo, self.course_id).first
    self.title = "Välj spelare"

    newButton = UIBarButtonItem.alloc.initWithTitle("+ NY", style: UIBarButtonItemStylePlain, target:self, action:'new')
    self.navigationItem.rightBarButtonItem = newButton
  end

  def init
    @players = Player.all({:sort => {:name => :desc}})
    @selected_players = []
    super
  end

  def viewDidLoad
    super
    layout tableView, :table
    tableView.rowHeight = 40
    @players = Player.all({:sort => {:name => :desc}})
    self.tableView.reloadData
  end

  def new
    controller = NewPlayerController.new
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
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    if @selected_players.length == 4
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    else
      select_player(players[indexPath.row])
    end
  end

  def select_player(player)
    @selected_players << player
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