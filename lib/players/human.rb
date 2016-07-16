module Players
  class Human < Player

    def move(board)
      puts "Where would you like to move? Select [1] - [9], where 1 is top\nleft and 9 is bottom right."
      gets.strip
    end
  end
end