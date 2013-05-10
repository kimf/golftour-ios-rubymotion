class DashboardController < UIViewController
  stylesheet :base

  def self.controller
    @controller ||= DashboardController.alloc.initWithNibName(nil, bundle:nil)
  end

  layout :root do
    self.title = "Simple Golftour"
  end

end