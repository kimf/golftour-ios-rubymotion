module Refreshable
  def viewDidLoad
    @refresh = UIRefreshControl.alloc.init
    @refresh.attributedTitle = NSAttributedString.alloc.initWithString("Dra för att uppdatera")
    @refresh.addTarget(self, action:'refreshView:', forControlEvents:UIControlEventValueChanged)
    self.refreshControl = @refresh
    super
  end

  def refreshView(refresh)
    refresh.attributedTitle = NSAttributedString.alloc.initWithString("Uppdaterar...")
    @on_refresh.call if @on_refresh
  end

  def on_refresh(&block)
    @on_refresh = block
  end

  def end_refreshing
    return unless @refresh

    @refresh.attributedTitle = NSAttributedString.alloc.initWithString("Uppdaterades senast: #{Time.now.strftime("%H:%M")}")
    @refresh.endRefreshing
  end

  def cancel_refreshing
    return unless @refresh
    @refresh.endRefreshing
  end
end
