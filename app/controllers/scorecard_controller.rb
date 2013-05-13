class ScorecardController < UIViewController
  stylesheet :base

  layout :root do
    self.title = "Scorekort"
    hideScorecardButton = UIBarButtonItem.alloc.initWithTitle("x", style: UIBarButtonItemStylePlain, target:self, action:'hide_scorecard')
    self.navigationItem.leftBarButtonItem = hideScorecardButton
    subview(UIButton, :cancel_button).on(:touch) do
      UIActionSheet.alert 'Vill du verkligen avbryta rundan?', buttons: ['Näää', 'Ja jag är trött!'],
        cancel: proc { },
        destructive: proc {
          App::Persistence['current_course_id'] = nil
          App::Persistence['current_player_ids'] = nil
          App.delegate.router.open("back_to_leaderboard")
        },
    end
  end



  def hide_scorecard
    App.delegate.router.pop
  end
end