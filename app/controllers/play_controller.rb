class PlayController < UIViewController
  

def viewWillAppear( animated ) 
  super
  navigationController.setNavigationBarHidden(true, animated: true )
end 

end