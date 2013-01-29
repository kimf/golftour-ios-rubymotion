class Player < NSRRemoteObject
  attr_accessor :tours, :scores, :scorecards, :name, :email, :is_public, :events, :points, :crypted_password, :salt, :remember_me_token, :remember_me_token_expires_at, :reset_password_token, :reset_password_token_expires_at, :reset_password_email_sent_at, :activation_state, :activation_token, :activation_token_expires_at, :last_login_at, :last_logout_at, :last_activity_at

  def remoteProperties
    super + ["tours", "scores", "scorecards", "name", "email", "is_public", "events", "points", "crypted_password", "salt", "remember_me_token", "remember_me_token_expires_at", "reset_password_token", "reset_password_token_expires_at", "reset_password_email_sent_at", "activation_state", "activation_token", "activation_token_expires_at", "last_login_at", "last_logout_at", "last_activity_at"]
  end

  def nestedClassForProperty(property)
    return Tour if property == "tours"
    return Score if property == "scores"
    return Scorecard if property == "scorecards"
  end

  def shouldOnlySendIDKeyForNestedObjectProperty(property)
    (property == "tours")
  end
end
