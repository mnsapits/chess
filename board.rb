=begin

Your Board class should hold a 2-dimensional array (an array of arrays).
Each position in the grid either holds a Piece, or NullPiece if no piece is present there.
You may want to create an empty Piece class as a placeholder for now.
Write code to setup the board correctly on initialize.
The Board class should have a #move(start, end_pos) method.
This should update the 2D grid and also the moved piece's position.
You'll want to raise an exception if: (a) there is no piece at start or (b) the piece cannot move to end_pos.


=end
require_relative "piece"
require_relative "display"
require 'byebug'

class Board
  attr_accessor :grid
  def dup
    duplicate_board = Board.new
    duplicate_board.grid.each_with_index do |row,i|
      row.each_with_index do |col,j|
        pos = [i,j]
        piece = self[pos].class
        next if piece == NullPiece
        color = self[pos].color
        piece.new(color, duplicate_board, pos)
      end
    end
    return duplicate_board
  end

  def initialize(grid = nil)
    @grid ||= Array.new(8) {Array.new(8, NullPiece.instance)}
    # for i in 0..7
    #   Pawn.new(:red, self, [1, i])
    #   Pawn.new(:blue, self, [6, i])
    # end
    # placement_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    # placement_order.each_with_index do |piece, index|
    #   piece.new(:red, self, [0, index])
    #   piece.new(:blue, self, [7, index])
    # end

  end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def []=(pos,piece)
    x,y = pos
    @grid[x][y] = piece
  end

  def make_move(start_pos,end_pos)
    piece = self[start_pos]
    available = piece.valid_moves
    raise "empty space" if piece.is_a? NullPiece
    if available.include?(end_pos)
      self[end_pos] = piece
      self[start_pos] = NullPiece.instance
    else
      puts "not valid move"
    end
  end

  def in_check?(color, king_pos = nil)
    king_pos ||= find_king(color)
    @grid.each_with_index do |row, i|
      row.each_with_index do |column, j|
        pos = [i,j]
        next if self[pos].is_a? NullPiece
        next if self[pos].color == color
        return true if (self[pos].move).include?(king_pos)
      end
    end

    false
  end

  def checkmate?(color)
    @grid.each do |row|
      row.each do |piece|
        next if piece.class == NullPiece
        next if piece.color != color
        return false if piece.valid_moves(color).length >= 1
      end
    end
    true
  end

  def find_king(color)
    @grid.each_with_index do |row, i|
      row.each_with_index do |column, j|
        pos = [i,j]
          return pos if self[pos].is_a?(King) && self[pos].color == color
      end
    end
  end




end


a = Board.new
k = King.new(:red,a,[0,0])
z = Queen.new(:blue, a,[0,3])
r= Rook.new(:red, a, [1, 1])
# x = Queen.new(:blue, a,[1,1])
# y = Queen.new(:blue, a,[1,0])

a_display = Display.new(a)
a_display.render
p a.checkmate?(:red)
