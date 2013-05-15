class SetupGameController < UITableViewController
  stylesheet :base

  layout :table do
    self.title = "Välj spelare"
    App::Persistence['current_player_ids'] = [App::Persistence["current_player_id"]]

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAdd,
      target: self,
      action: :add_player
    )

    @play_button = subview(UIButton, :play_button).on(:touch){ play }

    @reload_observer = App.notification_center.observe PlayerWasAddedNotification do |notification|
      self.tableView.reloadData
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    App::Persistence['current_player_ids'].count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      id = App::Persistence['current_player_ids'][indexPath.row]
      s  = Player.where(:id).eq(id).first
      cell.textLabel.text = "#{s.name}"
      cell.setSelectionStyle(UITableViewCellSelectionStyleNone)
    end
  end

  def add_player
    App.delegate.router.open("players", true)
  end

  def play
    App::Persistence['active_round'] = true
    App.delegate.router.open("playing", true)
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