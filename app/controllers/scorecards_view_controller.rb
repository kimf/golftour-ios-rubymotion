class ScorecardsViewController < UITableViewController
  stylesheet :scorecards_sheet
  include Refreshable

  attr_accessor :scorecards

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

  def viewWillAppear(animated)
    super
    self.title = "Golftour"
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @scorecards.count
  end

  def tableView(tableView, titleForHeaderInSection:section)
    "Scorecards"
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      s = @scorecards[indexPath.row]
      cell.textLabel.text = "#{s.course[0..27]}"
      cell.detailTextLabel.text = "#{s.time_of_day} of #{s.date}"

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
    @scorecards = Player.MR_findFirst.scorecards.allObjects
    SVProgressHUD.dismiss
    end_refreshing
    # Golftour.when_reachable do
    #   SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
    #   Player.current.scorecards do |results, response|
    #     SVProgressHUD.dismiss
    #     if response.ok? && results
    #       @scorecards = results
    #     else
    #       Golftour.offline_alert
    #     end
    #     tableView.reloadData
    #     end_refreshing
    #   end
    # end
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