require 'byebug'
require 'singleton'

class Piece

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1, 0],
    up_right: [-1,1],
    up_left: [-1,-1],
    down_right: [1,1],
    down_left: [1,-1]
  }

  attr_accessor :color, :board, :pos
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @board[pos] = self
  end
  def moves
  end

  def outside_or_blocked?(pos)
    x,y = pos
    return true if y > 7 or y < 0 or x > 7 or x < 0
    return false if @board[pos].is_a? NullPiece
    return true if @board[pos].color == self.color
    false
  end

  def valid_moves(color)
    self.move.reject do |final_pos|
      temp = self.board.dup
      temp.make_move(self.pos, final_pos)
      temp.in_check?(color)
    end
  end
end

class SlidingPiece < Piece
  def move
    starting_pos = @pos
    open_positions = []
    move_dirs.each do |direction|
      current_pos = starting_pos
      dx,dy = MOVES[direction]
      while true
        x,y = current_pos
        end_x = x + dx
        end_y = y + dy
        current_pos = [end_x, end_y]
        break if outside_or_blocked?(current_pos)
        open_positions << current_pos
        next if @board[current_pos].class == NullPiece
        break if @board[current_pos].color != self.color
      end
    end
    open_positions
  end
end

class SteppingPiece < Piece
  def move
    starting_pos = @pos
    open_positions = []
    move_dirs.each do |direction|
      current_pos = starting_pos
      dx,dy = MOVES[direction]
      x,y = current_pos
      end_x = x + dx
      end_y = y + dy
      current_pos = [end_x, end_y]
      next if outside_or_blocked?(current_pos)
      open_positions << current_pos
      next if @board[current_pos].class == NullPiece
      next if @board[current_pos].color != self.color
    end
    open_positions
  end
end

class Knight < SteppingPiece
  def type
    "H"
  end

  def move_dirs
    [ [-2, -1], [-2, 1], [2, -1], [2, 1],
      [-1, 2], [-1, - 2], [1, 2], [1, -2] ]
  end

  def move
    starting_pos = @pos
    open_positions = []
    move_dirs.each do |direction|
      current_pos = starting_pos
      dx,dy = direction
      x,y = current_pos
      end_x = x + dx
      end_y = y + dy
      current_pos = [end_x, end_y]
      next if outside_or_blocked?(current_pos)
      open_positions << current_pos
      next if @board[current_pos].class == NullPiece
      next if @board[current_pos].color != self.color
    end
    open_positions
  end
end

class King < SteppingPiece
  def type
    "K"
  end

  def move_dirs
    direction = MOVES.keys
  end
end

class Rook < SlidingPiece
  def type
    "R"
  end
  def move_dirs
    [:up, :down, :left, :right]
  end
end

class Pawn < Piece

  def type
    "P"
  end
  def move
    starting_pos = @pos
    x, y = starting_pos
    open_positions = []
    move_dirs.each do |direction|
      current_pos = starting_pos
      dx, dy = direction
      dx,dy = -dx,-dy if @color == :blue
      end_x = x + dx
      end_y = y + dy
      current_pos = [end_x, end_y]
      next if outside_or_blocked?(current_pos)
      next if !at_start_row?(starting_pos) && dx.abs == 2
      if straight?(direction)
        open_positions << current_pos
      else # diagonal
        next if @board[current_pos].is_a? NullPiece
        open_positions << current_pos if @board[current_pos].color != @color
      end
    end
    open_positions
  end

  def straight?(direction)
    direction.last == 0
  end


  def move_dirs
    [[2, 0], [1, 0], [1, -1], [1, 1]]
  end

  def at_start_row?(pos)
    if @color == :blue
      pos.first == 6
    else
      pos.first == 1
    end
  end

end

class Bishop < SlidingPiece
  def type
    "B"
  end
  def move_dirs
    [:up_left, :up_right, :down_left, :down_right]
  end
end

class Queen < SlidingPiece
  def type
    "Q"
  end
  def move_dirs
    direction = MOVES.keys
  end
end


class NullPiece
  include Singleton
  attr_accessor :type
  attr_reader :color

  def move
  end

  def type
    @type = '#'
  end

  def color
    @color = :white
  end

end
