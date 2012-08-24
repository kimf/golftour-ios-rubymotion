class Leaderboard
  PROPERTIES = [:players]

  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(hash = {})
    hash.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end

  def players
    @players ||= []
  end

  def players=(players)
    if players.first.is_a? Hash
      players = players.collect { |player| Player.new(player) }
    end

    players.each { |player|
      if not player.is_a? Player
        raise "Wrong class for attempted player #{player.inspect}"
      end
    }

    @players = players
  end
end