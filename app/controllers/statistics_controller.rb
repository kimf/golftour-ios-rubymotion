class StatisticsController < UIViewController




  def viewWillAppear( animated ) 
    super
    navigationController.setNavigationBarHidden(false, animated: true )
    self.tabBarController.navigationItem.title = "Statistics"
  end   

end