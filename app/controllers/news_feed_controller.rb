class NewsFeedController < UIViewController

  def viewWillAppear( animated ) 
    super
    navigationController.setNavigationBarHidden(false, animated: true ) 
    self.tabBarController.navigationItem.title = "Golftour"
  end   


  def viewDidLoad
    super
    @table_view = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStylePlain)
    self.view.addSubview(@table_view)
    @table_view.dataSource = self
    @table_view.delegate = self
  end


  def tableView(tableView, numberOfRowsInSection:section)
    100
  end


  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end


    #name view
    @name_view = UILabel.alloc.initWithFrame([[30, 10], [205, 20]])
    @name_view.text = "This is the text, maffaka!"
    cell.contentView.addSubview(@name_view)

    cell
  end
end