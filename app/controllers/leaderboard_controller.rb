class LeaderboardController < UITableViewController
  include Refreshable

  stylesheet :base

  attr_accessor :players

  layout :table do
    self.title = "Simple Golftour"
    @players = Player.order{|a, b| a.points <=> b.points}.all

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
                                              "left",
                                              style: UIBarButtonItemStyleBordered,
                                              target: viewDeckController,
                                              action: 'toggleLeftView'
                                            )

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemPlay,
        target: self,
        action: :play)

    @reload_observer = App.notification_center.observe PlayerWasAddedNotification do |notification|
      @players = Player.order{|a, b| a.points <=> b.points}.all
      self.tableView.reloadData
     end

    load_data if @players.length == 0

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
    modal_controller = UINavigationController.alloc.initWithRootViewController(SetupGameController.alloc.init)
    App.delegate.window.rootViewController.presentModalViewController(modal_controller, animated:true)
  end

  def load_data
    SVProgressHUD.showWithStatus("Synkar ledartavla", maskType:SVProgressHUDMaskTypeGradient)
    AFMotion::Client.shared.get("players?auth_token=#{App.delegate.auth_token}") do |result|
      if result.success?
        # result.object["tours"].each do |tour|
        #   existing_tour = Tour.where(:id).eq(tour["id"]).first || Tour.new
        #   existing_tour.id    = tour["id"]
        #   existing_tour.name  = tour["name"]
        #   existing_tour.save
        # end

        result.object["players"].each do |player|
          existing_player = Player.where(:id).eq(player["id"]).first
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

        @players = Player.order{|a, b| a.points <=> b.points}.all
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