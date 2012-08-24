class PlayersController < UITableViewController
  attr_accessor :leaderboard


  def init
    self.leaderboard = Leaderboard.new({"players"=>[{"name"=>"Kim", "id"=>1, "hcp"=>18.5, "email"=>"kim.fransman@gmail.com", "personal_best"=>82, "money"=>822}, {"name"=>"Garp", "id"=>3, "hcp"=>12.8999977111816, "email"=>"daniel.garpsater@gmail.com", "personal_best"=>80, "money"=>-51.0}, {"name"=>"Bolle", "id"=>2, "hcp"=>18.6999969482422, "email"=>"fredrik.k.bohlin@gmail.com", "personal_best"=>86, "money"=>-603.0}]})
    self
  end



  def viewDidLoad
    super
    @table_view = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStylePlain)
    self.view.addSubview(@table_view)
    @table_view.dataSource = self
    @table_view.delegate = self
  end

  def viewWillAppear( animated ) 
    super
    navigationController.setNavigationBarHidden(false, animated: true ) 
    self.tabBarController.navigationItem.title = "Standings"
  end   


  def tableView(tableView, numberOfRowsInSection:section)
    self.leaderboard.players.count
  end


  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    #position view
    @pos_view = UILabel.alloc.initWithFrame([[10, 10], [20, 20]])
    @pos_view.text = "#{indexPath.row + 1}"
    cell.contentView.addSubview(@pos_view)

    #name view
    @name_view = UILabel.alloc.initWithFrame([[30, 10], [205, 20]])
    @name_view.text = self.leaderboard.players[indexPath.row].name
    cell.contentView.addSubview(@name_view)

    #moneyview
    @money_view = UILabel.alloc.initWithFrame([[205, 10], [100, 20]])
    @money_view.text = "#{self.leaderboard.players[indexPath.row].money} kr"
    @money_view.backgroundColor = UIColor.yellowColor
    cell.contentView.addSubview(@money_view)
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    alert = UIAlertView.alloc.init
    alert.message = "#{self.leaderboard.players[indexPath.row].name} tapped!"
    alert.addButtonWithTitle "OK"
    alert.show
  end
end