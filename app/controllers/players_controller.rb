class PlayersController < UITableViewController
  stylesheet :table
  attr_accessor :players, :selected_players

  layout :table do
    self.title = "Välj spelare"

    newButton = UIBarButtonItem.alloc.initWithTitle("+", style: UIBarButtonItemStylePlain, target:self, action:'new')
    self.navigationItem.rightBarButtonItem = newButton

    subview(UIButton, :play_button).on(:touch){ play }
  end

  def viewWillAppear(animated)
    super
    App::Persistence['current_player_ids'] = nil
    @selected_players = []
    reload_players
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
  end


  def new
    App.delegate.router.open("new_player", true)
  end


  def play
    if @selected_players.length < 1
      App.alert("Du måste välja minst en spelare")
    else
      App.delegate.router.open("playing", true)
    end
  end

  def reload_players
    @players = Player.all({:sort => {:name => :desc}})
    self.tableView.reloadData
  end

  def toggle_player(player)
    if !@selected_players.include?(player)
      return false if @selected_players.length == 4
      @selected_players << player
    else
      @selected_players.delete(player)
    end
    App::Persistence['current_player_ids'] = @selected_players.map(&:id)
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