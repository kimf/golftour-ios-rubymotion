class DashboardController < UITableViewController
  include Refreshable

  stylesheet :table

  attr_accessor :players

  def self.controller
    @controller ||= DashboardController.alloc.initWithNibName(nil, bundle: nil)
  end

  layout :table do
    self.title = "Simple Golftour"
    playButton = UIBarButtonItem.alloc.initWithTitle("Spela!", style: UIBarButtonItemStylePlain, target:self, action:'play')
    self.navigationItem.rightBarButtonItem = playButton
  end

  def viewDidLoad
    @players = Player.all({:sort => {:points => :desc}})
    layout tableView, :table
    tableView.rowHeight = 60

    load_data

    on_refresh do
      load_data
    end

    super
  end


  def tableView(tableView, numberOfRowsInSection:section)
    @players.count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      p = @players[indexPath.row]
      cell.textLabel.text = "#{p.name}"
      cell.detailTextLabel.text = "#{p.average_points}p i snitt på #{p.rounds} rundor"

      score_label = UILabel.alloc.initWithFrame([[250, 10], [60, 30]])
      score_label.text = "#{p.points}"
      score_label.backgroundColor = "#444444".to_color
      score_label.textColor = UIColor.whiteColor
      score_label.textAlignment = NSTextAlignmentCenter
      score_label.layer.cornerRadius = 4
      cell.contentView.addSubview(score_label)
    end
  end


  # def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  #   player_controller = ScorecardViewController.alloc.init
  #   rvc.scorecard = scorecards[indexPath.row]
  # end


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


  def play
    controller = CoursesController.new
    navigationController = UINavigationController.alloc.initWithRootViewController(controller)
    navigationController.navigationBar.tintColor = "#1b8ad4".to_color
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical
    self.presentViewController(navigationController, animated: true, completion: lambda{})
  end


  private
    def fresh_cell
      tableView.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :cell do
          subview(UIView, :bottom_line)
        end

        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end

end
