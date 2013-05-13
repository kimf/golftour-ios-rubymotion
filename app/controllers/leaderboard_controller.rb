class LeaderboardController < UITableViewController
  include Refreshable

  stylesheet :table

  attr_accessor :players

  layout :table do
    self.title = "Leaderboard"
    @players = Player.all({:sort => {:points => :desc}})
    load_data

    on_refresh do
      load_data
    end
  end


  def tableView(tableView, numberOfRowsInSection:section)
    @players.count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      p = @players[indexPath.row]
      cell.textLabel.text = "#{p.name}"
      cell.detailTextLabel.text = "#{p.points}"
    end
  end


  def load_data
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
      elsif result.failure?
        App.alert(result.error.localizedDescription)
      end
      end_refreshing
    end

    return true
  end

  private
    def fresh_cell
      tableView.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :cell do
          subview(UIView, :bottom_line)
          subview(UILabel, :points_label)
        end

        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end

end
