class Score < NSRRemoteObject
  attr_accessor :scorecard, :player, :hole, :hcp, :par, :strokes, :points, :putts, :picked_up, :first_putt, :green, :club_to_green, :distance_to_green, :club_from_tee, :fir, :fairway, :h20, :ob, :chips, :green_bunker, :fairway_bunker, :penalties, :distance

  def remoteProperties
    super + ["scorecard", "player", "hole", "hcp", "par", "strokes", "points", "putts", "picked_up", "first_putt", "green", "club_to_green", "distance_to_green", "club_from_tee", "fir", "fairway", "h20", "ob", "chips", "green_bunker", "fairway_bunker", "penalties", "distance"]
  end

  def nestedClassForProperty(property)
    return Scorecard if property == "scorecard"
    return Player if property == "player"
  end

  def shouldOnlySendIDKeyForNestedObjectProperty(property)
    (property == "scorecard") || (property == "player")
  end
end


=begin

==================
Note:
==================

Overriding shouldOnlySendIDKeyForNestedObjectProperty above is necessary for any relationships that are 'belongs-to' on Rails.

* Returning NO means that when sending a Response, 'post' will be sent as a dictionary with remote key 'post_attributes'.

* Returning YES means that when sending a Response, only the remoteID from 'post' will be sent, with the remote key 'post_id'


This means that you don't need to define a postID attribute in your Response class, assign it a real Post object, and still have Rails be chill when receiving it! (Rails gets angry if you send it _attributes for a belongs-to relation.)

Of course, this is only relevant for belongs-to since you'd typically *want* the "_attributes" key in most cases.

=end