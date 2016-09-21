require "colorize"
require_relative "cursor"

class Display

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
  end

  def render
    print "  "
    (0..7).each { |num,i| print "#{num} " }
    puts ''
    @cursor.board.grid.each_with_index do |row,i|
      print "#{i} "
      row.each_with_index do |piece,j|
        if @cursor.cursor_pos == [i,j]
          print piece.type.colorize(:green)
        else
          print piece.type.colorize(piece.color)
        end
        print ' '
      end
      puts ''
    end
  end
  def make_move
    5.times do
      render
      @cursor.get_input
      system "clear"
    end
  end
end
