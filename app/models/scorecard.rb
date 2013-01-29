class Scorecard < NSRRemoteObject
  attr_accessor :player, :scores, :date, :time_of_day, :course, :par, :distance, :notes, :scores_count, :out, :in, :strokes, :points, :putts, :tee

  def remoteProperties
    super + ["player", "scores", "date", "time_of_day", "course", "par", "distance", "notes", "scores_count", "out", "in", "strokes", "points", "putts", "tee"]
  end

  def nestedClassForProperty(property)
    Score if property == "scores"
    #Player if property == "player"
  end

  def shouldOnlySendIDKeyForNestedObjectProperty(property)
    (property == "player")
  end
end
