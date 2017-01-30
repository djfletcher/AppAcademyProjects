require '/Users/appacademy/Desktop/W1D1/Ghost/player.rb'

class Game

  def initialize(player_names)
    @players = player_names.map { |name| Player.new(name) }
    @remaining_players = @players
    @current_player = @remaining_players.first
    @previous_player = @remaining_players.last
    @fragment = ""
    @dictionary = read_file("dictionary.txt")
  end

  def round_won?
    @dictionary.include?(@fragment)
  end

  def game_won?
    @remaining_players.size == 1
  end

  def winner
    @remaining_players[0]
  end

  def play
    until game_won?
      play_round
      display_score
      @fragment = ""
    end
    puts "Game is over! #{winner} wins!"
  end

  def display_score
    @players.each do |player|
      puts "#{player.name} is a #{player.ghost}"
    end
  end

  def play_round
    until round_won?
      take_turn
    end

    print "The round is OVER. The fragment \"#{@fragment}\" is a word. "
    puts "#{@previous_player.name} lost!"
    @previous_player.lost_round
    @remaining_players.delete(@previous_player) if @previous_player.lost_game?
  end

  def next_player!
    @previous_player = @current_player
    new_player_index = @remaining_players.index(@current_player) + 1
    new_player_index = new_player_index % @remaining_players.size
    @current_player = @players[new_player_index]
  end

  def valid_play?(letter)
    return false unless ('a'..'z').include?(letter)
    @dictionary.any? do |word|
      word.start_with?(@fragment + letter)
    end
  end

  def take_turn
    valid_guess = false
    until valid_guess
      letter = @current_player.take_turn(@fragment)
      valid_guess = valid_play?(letter)
      @current_player.alert_invalid_guess unless valid_guess
    end

    @fragment += letter
    next_player!
  end

  def read_file(file)
    words = File.readlines(file)
    words.map { |word| word.chomp }
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new(['Michael', 'Daniel', 'God']).play
end
