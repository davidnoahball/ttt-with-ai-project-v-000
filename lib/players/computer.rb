module Players
  class Computer < Player
    def initialize(token, delay=0)
      @token = token
      @delay = delay

      @turn_count = 0
      @turn_limit = 0
      @changes_data = [
        [0, 0, 0, 0, 0]
      ]
      @changes = [0, 0, 0, 0, 0] #rots, horizs, verts, 19s, 37s
      @moves = [] #0-8s in permuted form
      @cells = ["1", "2", "3", "4", "5", "6", "7", "8", "9"] #will be changed, allowing for rotations, etc.
    end

#-------------AI----------------  #RETURN 1-9 in string form.
def move(board)
  @turn_count = 0 #once equals # of previous moves - 1, returns. Iterate by 2 every tree step.
  sleep(@delay) #delays for anthropomorphism
  first = board.turn_count % 2 == 0 #will be used for splitting logic later
  turn = board.turn_count + 1 #current turn count, in form 1-9
  @turn_limit = turn - 2 #number of previous moves - 1
  reset! #every move will rerun over logic and needs a clean slate of @cells

  if turn == 9 #only one move allowed here, so loic simple and final move means fomality unnecessary
    (1..9).each do |move|
      if board.valid_move?(move.to_s) then return move.to_s end
    end
  end
  if turn == 1 #dealing with edge cases by separating logic which is simple anyway
    #return finishing(6, [rand(4), 0, 0, 0, 0])
    return finishing(6, [0, 0, 0, 0, 0])
  end

  permute! #allows for correction of @cells to be grabbed from
  @moves << @cells[board.recent].to_i - 1 #takes in most recent move, permuted for n - 1
  reset! #always reset after adding or changeing a move b/c permute will fix it later

  if first #categorizing logic
    @turn_count += 1 #accounting for the fact that we went first and so the final move count is odd

    if @moves[@turn_count] == 4 #tree logic that opponent picked middle move
      if @turn_count == @turn_limit #if middle move was most recent move
        return finishing(2) #return the correct move
      end
      @turn_count += 2 #now pointing to next opponent move

      change(0, 8, [0, 0, 0, 0, 1]) #standardizing opponent's moves
      change(1, 7, [2, 0, 0, 0, 0])
      change(3, 7, [0, 0, 0, 0, 1])
      change(5, 7, [0, 0 ,0, 1, 0])
      if @moves[@turn_count] == 8
        if @turn_count == @turn_limit
          return finishing(0)
        end
        @turn_count += 2

        change(1, 3, mirror_19!)
        if @moves[@turn_count] == 3
          if @turn_count == @turn_limit
            return finishing(1)
          end
        end

      end
      if @moves[@turn_count] == 7
        if @turn_count == @turn_limit
          return finishing(1)
        end
        @turn_count += 2

        if @moves[@turn_count] == 0
          if @turn_count == @turn_limit
            return finishing(8)
          end
        end
        if @moves[@turn_count] != 0
          if @turn_count == @turn_limit
            return finishing(0)
          end
        end
      end
    end
  else

  end
end #follows format of tree based on if @moves[@turn_count] == (one of possibilities), where the turn
    #count always points ot an opponent's move. If the @turn_count points to the @turn_limit, e.g.
    #we've reached the point that we have to come up with a move to respond to the most recent,
    #we change the move to standardized form and then respond with our move. This means that we
    #have to check on every even if we go second, odd if first.

#------------HELPERS------------ #I started using instance variables to work cross-method.
def finishing(cells_idx, changes=nil) #called after updating recent human move; @turn_count = @turn_limit
  permute!
  if changes #if multiple options for our move exist, we can pass in [changes] in [0, 0, 0, 0, 0] form
             #where the changes result in acceptable positions for our input (see if turn == 1)
    permute!(true, changes)
  end
  @moves << cells_idx
  return @cells[cells_idx]
end

def reset!
  @cells = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
end

# I know I should use procs for this next method, but I don't feel like reviewing it right now.
def change(move, replacement, changes) #moves given in 0-8 form; updates prev move
  if @turn_count == @turn_limit && @moves[@turn_count] == move
    permute!
    permute!(true, changes)
    reset!
    @moves[@turn_count] = replacement
  end
end

def permute!(update=false, changes=@changes) #updates @cells with all changes
  rotate!(@cells, changes[0], update)
  mirror_horiz!(@cells, changes[1], update)
  mirror_vert!(@cells, changes[2], update)
  mirror_19!(@cells, changes[3], update)
  mirror_37!(@cells, changes[4], update)
end
#all below just change @cells from their preivous state to account for mirrors, rotations, etc.
def rotate!(cells=@cells, reps=1, change=true)
  reps.times do |n|
    if change then @changes[0] += 1 end
    @cells = [cells[2], cells[5], cells[8], cells[1], cells[4], cells[7], cells[0], cells[3], cells[6]]
    cells = @cells
  end
end

def mirror_horiz!(cells=@cells, reps=1, change=true)
  reps.times do |n|
    if change then @changes[1] += 1 end
    @cells = [cells[2], cells[1], cells[0], cells[5], cells[4], cells[3], cells[8], cells[7], cells[6]]
    cells = @cells
  end
end

def mirror_vert!(cells=@cells, reps=1, change=true)
  reps.times do |n|
    if change then @changes[2] += 1 end
    @cells = [cells[6], cells[7], cells[8], cells[3], cells[4], cells[5], cells[0], cells[1], cells[2]]
    cells = @cells
  end
end
def mirror_19!(cells=@cells, reps=1, change=true) #diagonally top-left bottom-right
  reps.times do |n|
    if change then @changes[3] += 1 end
    @cells = [cells[0], cells[3], cells[6], cells[1], cells[4], cells[7], cells[2], cells[5], cells[8]]
    cells = @cells
  end
end
def mirror_37!(cells=@cells, reps=1, change=true) #the oher diagonal
  reps.times do |n|
    if change then @changes[4] += 1 end
    @cells = [cells[8], cells[5], cells[2], cells[7], cells[4], cells[1], cells[6], cells[3], cells[0]]
    cells = @cells
  end
end
#------------END AI-------------
  end
end