class PlayersController < UITableViewController
  stylesheet :base
  attr_accessor :players

  layout :table do
    @players = Player.order(:name).all
  end

  def viewDidLoad
    super
    self.title = "Spelare"

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemDone,
        target: self,
        action: :cancel)


    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemAdd,
        target: self,
        action: :add_player)

    @reload_observer = App.notification_center.observe PlayerWasAddedNotification do |notification|
      @players << notification.object
      self.tableView.reloadData
    end
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
    App.notification_center.post PlayerWasAddedNotification, @players[indexPath.row]
    self.navigationController.pop
  end


  def add_player
    self.navigationController << NewPlayerController.alloc.init
  end

  def cancel
    self.navigationController.pop
  end

  private
    def fresh_cell
      tableView.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :default_cell do
          subview(UIView, :bottom_line)
        end
        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end
end