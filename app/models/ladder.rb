class Ladder
  def self.current
    new
  end

  def players
    Player.in_elo_order
  end
end
