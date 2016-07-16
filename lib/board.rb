class Board
  attr_accessor :cells, :recent

  def initialize
    @cells = Array.new(9, " ")
  end

  def reset!
    @cells = Array.new(9, " ")
  end

  def display
    puts ""
    puts " #{@cells[0]} | #{@cells[1]} | #{@cells[2]} "
    puts "-----------"
    puts " #{@cells[3]} | #{@cells[4]} | #{@cells[5]} "
    puts "-----------"
    puts " #{@cells[6]} | #{@cells[7]} | #{@cells[8]} "
    puts ""
  end

  def position(input)
    @cells[input.to_i - 1]
  end

  def full?
    @cells.each do |cell|
      if cell == " " then return false end
    end
    true
  end

  def turn_count
    @cells.reject{|cell| cell == " "}.length
  end

  def taken?(pos)
    return ["X", "O"].include?(position(pos))
  end

  def valid_move?(input)
    position(input) == " " && input.to_i >=1 && input.to_i <= 9
  end

  def update(pos, player)
    @cells[pos.to_i - 1] = player.token
  end
end