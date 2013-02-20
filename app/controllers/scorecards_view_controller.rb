class ScorecardsViewController < UITableViewController
  include Refreshable

  attr_accessor :scorecards

  def init
    @scorecards = []
    super
  end

  def viewDidLoad
    self.title = "Scorecards"
    tableView.rowHeight = 60

    load_data

    on_refresh do
      load_data
    end

    super
  end

  def viewWillAppear(animated)
    super
    tableView.reloadData
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @scorecards.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')

    s = @scorecards[indexPath.row]

    cell.textLabel.text = "#{s.course[0..27]}"
    cell.detailTextLabel.text = "#{s.time_of_day} of #{s.date}"

    score_label = UILabel.alloc.initWithFrame([[280, 10], [30, 30]])
    score_label.text = "#{s.strokes}"
    score_label.backgroundColor = UIColor.grayColor
    score_label.textColor = UIColor.whiteColor
    score_label.textAlignment = NSTextAlignmentCenter
    score_label.layer.cornerRadius = 4
    cell.contentView.addSubview(score_label)

    cell
  end

  # def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
  #   deleteScorecardAtIndexPath indexPath
  # end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    rvc = ScorecardViewController.alloc.init
    rvc.scorecard = scorecards[indexPath.row]
    self.navigationController.pushViewController rvc, animated:true
  end


  def load_data
    Golftour.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      Scorecard.find_all do |results, response|
        SVProgressHUD.dismiss
        if response.ok? && results
          @scorecards = results
        else
          Golftour.offline_alert
        end
        tableView.reloadData
        end_refreshing
      end
    end
  end

end