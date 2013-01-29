class Tour < NSRRemoteObject
  attr_accessor :players, :name

  def remoteProperties
    super + ["players", "name"]
  end

  def nestedClassForProperty(property)
    return Player if property == "players"
  end

  def shouldOnlySendIDKeyForNestedObjectProperty(property)
    (property == "players")
  end
end
