=begin

Your Board class should hold a 2-dimensional array (an array of arrays).
Each position in the board either holds a Piece, or NullPiece if no piece is present there.
You may want to create an empty Piece class as a placeholder for now.
Write code to setup the board correctly on initialize.
The Board class should have a #move(start, end_pos) method.
This should update the 2D grid and also the moved piece's position.
You'll want to raise an exception if: (a) there is no piece at start or (b) the piece cannot move to end_pos.


=end
require_relative "piece"
require_relative "display"

class Board
  attr_accessor :board
  def initialize
    @board = Array.new(8) {Array.new(8,NullPiece.new)}
  end
  def [](pos)
    x,y = pos
    @board[x][y]
  end
  def []=(pos,piece)
    x,y = pos
    @board[x][y] = piece
  end
  def move(start_pos,end_pos)
    piece = @board[start_pos]
    if piece.valid_move?
      @board[end_pos] = piece
      @board[start_pos] = NullPiece.new
    else
      puts "not valid move"
    end
  end

end


a = Board.new
k = King.new("black", a,[5,6])
r = Knight.new("black", a,[7,7])
p r.move
# a[[4,4]] = r
a_display = Display.new(a)
a_display.render
# a_display.make_move
