class ScorecardsViewController < UITableViewController
  # def add
  #   # When the + button is hit, display an InputViewController (this is the shared input view for both scorecards and responses)
  #   # It has an init method that accepts a completion block - this block of code will be executed when the user hits "save"

  #   new_scorecard_vc = InputViewController.alloc.init
  #   new_scorecard_vc.completion_block = lambda do |player, content|
  #     new_scorecard = Scorecard.alloc.init
  #     new_scorecard.player = player

  #     ptr = Pointer.new(:object)
  #     if !new_scorecard.remoteCreate(ptr)
  #       AppDelegate.alertForError ptr[0]
  #       # Don't dismiss the input VC
  #       return false
  #     end

  #     @scorecards.insert(0, new_scorecard)
  #     self.tableView.reloadData

  #     true
  #   end

  #   new_scorecard_vc.header = "Scorecard something to NSRails.com!"
  #   new_scorecard_vc.message_placeholder = "A comment about NSRails, a philosophical inquiry, or simply a \"Hello world\"!"

  #   nav = UINavigationController.alloc.initWithRootViewController new_scorecard_vc

  #   self.navigationController.presentModalViewController nav, animated:true
  # end


  # def deleteScorecardAtIndexPath(indexPath)
  #   scorecard = @scorecards[indexPath.row]

  #   p = Pointer.new(:object)
  #   if scorecard.remoteDestroy(p)
  #     # Remember to delete the object from our local array too
  #     @scorecards.delete(scorecard)
  #     self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationAutomatic)
  #   else
  #     AppDelegate.alertForError p[0]
  #   end
  # end

  # # # # # # # # #
  #
  # UI and table stuff
  #
  # # # # # # # # #

  def loadView
    self.tableView = UITableView.new
  end

  def viewDidLoad
    super

    self.title = "Scorecards"
    self.tableView.rowHeight = 60

    # # Add + button
    # addBtn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:(:add))
    # self.navigationItem.rightBarButtonItem = addBtn

    @scorecards = []
    self.refreshTableHeaderDidTriggerRefresh(self.tableView)
  end

  def viewDidAppear(animated)
    @refreshHeaderView ||= begin
       rhv = RefreshTableHeaderView.alloc.initWithFrame(CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
       rhv.delegate = self
       rhv.refreshLastUpdatedDate
       tableView.addSubview(rhv)
       rhv
     end
  end

  def numberOfSectionsInTableView(tableView)
    10
  end

  def tableView(tableView, numberOfRowsInSection:section)
    return 0 if !@scorecards
    @scorecards.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@reuseIdentifier)
    end

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

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    deleteScorecardAtIndexPath indexPath
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    scorecard = @scorecards[indexPath.row]

    rvc = ScorecardViewController.alloc.init
    rvc.scorecard = scorecard
    self.navigationController.pushViewController rvc, animated:true
  end

  def reloadTableViewDataSource
    @reloading = true
  end

  def doneReloadingTableViewData
    @reloading = false
    @refreshHeaderView.refreshScrollViewDataSourceDidFinishLoading(self.tableView)
  end

  def scrollViewDidScroll(scrollView)
    @refreshHeaderView.refreshScrollViewDidScroll(scrollView)
  end

  def scrollViewDidEndDragging(scrollView, willDecelerate:decelerate)
    @refreshHeaderView.refreshScrollViewDidEndDragging(scrollView)
  end

  def refreshTableHeaderDidTriggerRefresh(view)
    e_ptr = Pointer.new(:object)
    if @scorecards.remoteFetchAll(Scorecard, error:e_ptr)
      self.reloadTableViewDataSource
      self.performSelector('doneReloadingTableViewData', withObject:nil, afterDelay:1)
    else
      AppDelegate.alertForError e_ptr[0]
    end
  end

  def refreshTableHeaderDataSourceIsLoading(view)
    @reloading
  end

  def refreshTableHeaderDataSourceLastUpdated(view)
    NSDate.date
  end
end