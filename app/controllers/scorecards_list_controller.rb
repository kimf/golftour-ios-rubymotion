class ScorecardsListController < UITableViewController
  SCORECARDS_ENDPOINT =  + "/#{NSBundle.mainBundle.objectForInfoDictionaryKey('API_URL')}/scorecards?auth_token=#{App::Persistence['authToken']}"
  stylesheet :scorecards_sheet
  include Refreshable

  attr_accessor :scorecards

  def self.controller
    @controller ||= ScorecardsListController.alloc.initWithNibName(nil, bundle:nil)
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
    @scorecards = []
    BW::HTTP.post(API_REGISTER_ENDPOINT, { headers: headers , payload: data } ) do |response|
      json = BW::JSON.parse(response.body.to_s)
      json['scorecards'].each do |scorecard|
        @scorecards << scorecard
      end
      SVProgressHUD.dismiss
      end_refreshing
    end


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