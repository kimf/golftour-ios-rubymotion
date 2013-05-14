class LeaderboardController < UITableViewController
  include Refreshable

  stylesheet :base

  attr_accessor :players

  layout :table do
    self.title = "Ledartavla"
    @players = Player.all({:sort => {:points => :desc}})

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemStop,
        target: self,
        action: :logout)


    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemPlay,
        target: self,
        action: :play)

    @reload_observer = App.notification_center.observe PlayerWasAddedNotification do |notification|
      @players = Player.all({:sort => {:points => :desc}})
      self.tableView.reloadData
     end

    load_data

    on_refresh do
      load_data
    end
  end


  def tableView(tableView, numberOfRowsInSection:section)
    @players.count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    p = @players[indexPath.row]
    subview(UITableViewCell, :empty_cell) do |cell|
      subview(UILabel, :player_position_label, text: "#{indexPath.row + 1}")
      subview(UILabel, :player_name_label, text: "#{p.name}")
      subview(UILabel, :player_rounds_label, text: "#{p.rounds}")
      subview(UILabel, :player_points_label, text: "#{p.points}")
      subview(UIView, :bottom_line)

      cell.setSelectionStyle(UITableViewCellSelectionStyleNone)
    end
  end

  def tableView(tableView, viewForHeaderInSection:section)
    subview(UIView, :table_header) do
      @player_label = subview(UILabel, :player_label)
      @round_label  = subview(UILabel, :round_label)
      @points_label = subview(UILabel, :points_label)
    end
  end


  def play
    App.delegate.router.open("courses", true)
  end

  def logout
    UIActionSheet.alert 'Vill du verkligen logga ut?', buttons: ['Näää', 'Japp!'],
      cancel: proc { },
      destructive: proc {
        App::Persistence['authToken'] = nil
        App.delegate.router.open("login")
      }
  end

  def load_data
    SVProgressHUD.showWithStatus("Synkar ledartavla", maskType:SVProgressHUDMaskTypeGradient)
    AFMotion::Client.shared.get("players?auth_token=#{App.delegate.auth_token}") do |result|
      if result.success?
        result.object["players"].each do |player|
          existing_player = Player.find(:id, NSFEqualTo, player["id"]).first
          if !existing_player
            puts "Creating new"
            Player.create(
              id: player["id"].to_i,
              name: player["name"],
              points: player["points"].to_i,
              rounds: player["rounds"].to_i,
              average_points: player["average_points"].to_i,
              hcp: player["hcp"],
              email: player["email"]
            )
          else
            existing_player.name   = player["name"]
            existing_player.points = player["points"].to_i
            existing_player.rounds = player["rounds"].to_i
            existing_player.average_points = player["average_points"].to_i
            existing_player.hcp = player["hcp"]
            existing_player.email = player["email"]
            existing_player.save
          end
        end
        @players = Player.all({:sort => {:points => :desc}})
        self.tableView.reloadData
        SVProgressHUD.dismiss
      elsif result.failure?
        App.alert(result.error.localizedDescription)
        SVProgressHUD.dismiss
      end
      end_refreshing
    end

    return true
  end
end