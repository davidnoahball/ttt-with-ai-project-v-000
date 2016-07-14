class Game
  attr_accessor :board, :player_1, :player_2
  WIN_COMBINATIONS = [ #taken from old
    [0,1,2], # Top row
    [3,4,5], # Middle row
    [6,7,8], # Bottom row
    [0,3,6],
    [0,4,8],
    [1,4,7],
    [2,5,8],
    [6,4,2]
  ]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
  end

  #BEGIN slightly altered old code
  def current_player
    @board.turn_count % 2 == 0 ? @player_1 : @player_2
  end

  def over?
    won? || draw?
  end

  def xs_n_os_
    xs = []
    os = []
    @board.cells.each_with_index do |item, idx|
      if item == "X" then xs << idx end
      if item == "O" then os << idx end
    end
    return [xs, os]
  end

  def won?
    xs_n_os = xs_n_os_
    WIN_COMBINATIONS.each do |com|
      if com.all?{|pos| xs_n_os != nil && xs_n_os[0].include?(pos)} then return true end
      if com.all?{|pos| xs_n_os != nil && xs_n_os[1].include?(pos)} then return true end
    end
    return false
  end

  def draw?
    return (!won? && @board.full?)
  end

  def winner
    win = won?
    if win == false then return nil end
    xs_n_os = xs_n_os_
    WIN_COMBINATIONS.each do |com|
      if com.all?{|pos| xs_n_os[0].include?(pos)} then return "X" end
      if com.all?{|pos| xs_n_os[1].include?(pos)} then return "O" end
    end
  end

  def play
    while !over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    else
      puts "Cats Game!"
    end
  end
  #END slightly altered old code

  def turn
    current_move = self.current_player.move(@board)
    if !@board.valid_move?(current_move)
      puts "That was not a valid move. Please try again."
      turn
    else
      @board.update(current_move, self.current_player)
      @board.display
    end
  end

end