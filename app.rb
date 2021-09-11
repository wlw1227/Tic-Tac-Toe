class Player 
  attr_reader :token, :name

  def initialize(gameplay, token, name)
    @gameplay = gameplay
    @token = token
    @name = name
  end 

  def make_move
    loop do 
      puts "#{@name}, pick an available number to make your move:"
      user_input = gets.chomp.to_i
      if @gameplay.available_positions.include?(user_input)
        return user_input 
      end 
      puts "\nTry another number"
    end
  end

end

class GamePlay
  WINNING_COMBINATIONS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [6, 4, 2],
  ]

  attr_reader :available_positions

  def initialize
    @players = [
      Player.new(self, 'X', 'Player1'),
      Player.new(self, 'O', 'Player2')
    ]
    @board = %w[1 2 3 4 5 6 7 8 9]
    @current_player = @players[0]
    @available_positions = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end 

  def play
    loop do
      puts "\nGame board:"
      display_board
      chosen_position = @current_player.make_move
      update_available_positions(chosen_position)
      @board[chosen_position - 1] = @current_player.token

      if winner?(@current_player)
        display_board
        puts "The winner is #{@current_player.name}!"
        play_again?
      elsif draw?
        display_board
        puts "It's a draw!"
        play_again?
      end

      switch_player
    end
  end

  def update_available_positions(num)
    @available_positions.delete(num)
  end

  def display_board
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]}"
    puts "---+---+---"
    puts " #{@board[3]} | #{@board[4]} | #{@board[5]}"
    puts "---+---+---"
    puts " #{@board[6]} | #{@board[7]} | #{@board[8]}"
  end 

  def winner?(player)
    WINNING_COMBINATIONS.any? do |combination|
      combination.all? { |pos| @board[pos - 1] == player.token}
    end
  end

  def draw?
    @available_positions.empty? 
  end 

  def switch_player
    @current_player = @current_player == @players[0] ? @players[1] : @players[0]
  end

  def play_again?
    loop do
      print "\nPlay again? y/n:"
      answer = gets.chomp.downcase
      if answer == 'n'
        exit
      elsif answer == 'y'
        initialize
        play
      end
    end
  end

end
  
new_game = GamePlay.new
new_game.play
