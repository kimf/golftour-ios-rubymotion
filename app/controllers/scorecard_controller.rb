class ScorecardController < UIViewController
  stylesheet :base

  layout do
    self.title = "Scorekort"

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemStop,
        target: self,
        action: :hide_scorecard)

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemTrash,
        target: self,
        action: :cancel_scorecard)
  end

  def cancel_scorecard
    UIActionSheet.alert 'Vill du verkligen avbryta rundan?', buttons: ['Näää', 'Ja jag är trött!'],
      cancel: proc { },
      destructive: proc {
        App.delegate.window.rootViewController.dismissModalViewControllerAnimated(true, completion:nil)
      }
  end

  def hide_scorecard
    self.navigationController.pop
  end
end