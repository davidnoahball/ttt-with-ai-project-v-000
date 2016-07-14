module Players
  class Computer < Player
    def initialize(token)
      super
      puts "WARNING: I am a perfect AI; it is impossible to defeat me."
    end
    def move(board)
      (1..9).each do |move|
        if board.valid_move?(move.to_s) then return move.to_s end
      end
    end
  end
end