class ScorecardsListController < UITableViewController
  stylesheet :scorecards_sheet
  include Refreshable

  attr_accessor :scorecards

  def self.controller
    @controller ||= ScorecardsListController.alloc.initWithNibName(nil, bundle:nil)
  end

  layout :table do
    self.title = "Simple Golftour"
    @scorecards = Scorecard.all
    playButton = UIBarButtonItem.alloc.initWithTitle("Play!", style: UIBarButtonItemStylePlain, target:self, action:'play')
    self.navigationItem.rightBarButtonItem = playButton
  end

  def init
    @scorecards = []
    super
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
    @scorecards.count || 0
  end

  def tableView(tableView, titleForHeaderInSection:section)
    "Scorecards"
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      s = @scorecards[indexPath.row]
      cell.textLabel.text = "#{s.course[0..22]}"
      cell.detailTextLabel.text = "#{s.played_at}"

      score_label = UILabel.alloc.initWithFrame([[280, 10], [30, 30]])
      score_label.text = "#{s.strokes}"
      score_label.backgroundColor = UIColor.colorWithRed(62.0/255, green: 69.0/255, blue: 95.0/255, alpha:1)
      score_label.textColor = UIColor.whiteColor
      score_label.textAlignment = NSTextAlignmentCenter
      score_label.layer.cornerRadius = 4
      cell.contentView.addSubview(score_label)
    end
  end

  # def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
  #   deleteScorecardAtIndexPath indexPath
  # end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    rvc = ScorecardViewController.alloc.init
    rvc.scorecard = scorecards[indexPath.row]
  end

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
    SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)

    BW::HTTP.get("#{App.delegate.server}/scorecards?auth_token=#{App.delegate.auth_token}" ) do |response|
      json = BW::JSON.parse(response.body.to_s)
      json["scorecards"].each do |scorecard|
        existing = Scorecard.find(:id, NSFEqualTo, scorecard["id"])
        if existing.length == 0
          puts "Creating new"
          Scorecard.create_new(
            scorecard["id"],
            scorecard["course"],
            scorecard["par"],
            scorecard["strokes"],
            scorecard["date"]
          )
        end
      end
      @scorecards = Scorecard.all
      self.tableView.reloadData
      SVProgressHUD.dismiss
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
          subview(UIView, :top_line)
          subview(UIView, :bottom_line)
        end

        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end
end