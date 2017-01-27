class Player

  attr_reader :name
  attr_accessor :losses

  def initialize(name)
    @name = name
    @losses = 0
  end

  def lost_round
    @losses += 1
  end

  def lost_game?
    @losses == 5
  end

  def alert_invalid_guess
    puts "Invalid Guess"
  end

  def ghost
    "GHOST"[0..@losses - 1] if @losses > 0
  end

  def take_turn(fragment)
    puts "Fragment is \"#{fragment}\""
    puts "#{@name}, choose a letter: "
    gets.chomp
  end

end
