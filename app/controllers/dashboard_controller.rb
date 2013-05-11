class DashboardController < UITableViewController
  include Refreshable

  stylesheet :scorecards_sheet

  attr_accessor :players

  def self.controller
    @controller ||= DashboardController.alloc.initWithNibName(nil, bundle: nil)
  end

  layout :table do
    self.title = "Simple Golftour"
    @players = []
    playButton = UIBarButtonItem.alloc.initWithTitle("Spela!", style: UIBarButtonItemStylePlain, target:self, action:'play')
    self.navigationItem.rightBarButtonItem = playButton
  end

  def viewDidLoad
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

  def tableView(tableView, titleForHeaderInSection:section)
    "Ledartavla"
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      p = @players[indexPath.row]
      cell.textLabel.text = "#{p.name}"
      cell.detailTextLabel.text = "#{p.average_points}p i snitt på #{p.rounds} rundor"

      score_label = UILabel.alloc.initWithFrame([[250, 10], [60, 30]])
      score_label.text = "#{p.points}"
      score_label.backgroundColor = UIColor.colorWithRed(62.0/255, green: 69.0/255, blue: 95.0/255, alpha:1)
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

  def tableView(tableView, viewForHeaderInSection:section)
    view = UIView.alloc.initWithFrame([[0, 0], [320, 30]])
    layout(view, :header) do
      subview(UIView, :bottom_line)
      label = subview(UILabel, :header_label)
      label.text = tableView(tableView, titleForHeaderInSection:section)
    end
    view
  end


  def load_data
    if App.delegate.is_authenticated
      SVProgressHUD.showWithStatus("Uppdaterar ledartavla", maskType:SVProgressHUDMaskTypeGradient)
      BW::HTTP.get("#{App.delegate.server}/players?auth_token=#{App.delegate.auth_token}" ) do |response|
        json = BW::JSON.parse(response.body.to_s)
        json["players"].each do |player|
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
        end_refreshing
      end
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
          subview(UIView, :top_line)
          subview(UIView, :bottom_line)
        end

        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end

end
