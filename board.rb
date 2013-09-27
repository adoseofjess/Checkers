require './piece'
require 'colorize'

class Board
	attr_accessor :grid
		
	def initialize
	  @grid = Array.new(8) { Array.new(8) }
    place_pieces
	end
	
	def place_pieces
    @grid[0..2].each_with_index do |row, row_num|
      row.each_with_index do |row, square|
        if row_num.even? && square.even? 
          @grid[row_num][square] = Piece.new(:red, [row_num, square], self)
        elsif row_num.odd? && square.odd?
          @grid[row_num][square] = Piece.new(:red, [row_num, square], self)
        end
      end
    end

    @grid[0..2].each_with_index do |row, row_num|
      row.each_with_index do |row, square|
        if row_num.even? && square.odd? 
          @grid[row_num+5][square] = Piece.new(:black, [row_num+5, square], self)
        elsif row_num.odd? && square.even?
          @grid[row_num+5][square] = Piece.new(:black, [row_num+5, square], self)
        end
      end
    end
  end

  def [](x, y)
    @grid[x][y]
  end  
  
  def []=(x, y, piece)
    self[x, y] = piece
    piece.position = [x, y]
  end
  
  def perform_slide(start_pos, end_pos)
    piece = self[start_pos[0], start_pos[1]]
    destinations = piece.slide_moves 
    if destinations.include?(end_pos) && self[end_pos[0], end_pos[1]].nil?
      @grid[end_pos[0]][end_pos[1]] = self[start_pos[0], start_pos[1]]
      self[start_pos[0], start_pos[1]].position = [end_pos[0], end_pos[1]]
      @grid[start_pos[0]][start_pos[1]] = nil
      if piece.color == :black && end_pos[0] == 0
        piece.now_a_king
      elsif piece.color == :red && end_pos[0] == 7
        piece.now_a_king
      end 
    else
      # fill in error messages later
      puts "didn't work"
    end
  end
  
  def perform_jump(start_pos, end_pos)
    piece = self[start_pos[0], start_pos[1]]
    destinations = piece.jump_moves
    in_between_square = in_between_square(start_pos, end_pos)
    
    if !destinations.include?(end_pos)
      raise "That piece can't jump there"
    end
    if !self[end_pos[0], end_pos[1]].nil?
      raise "There's already a piece there"
    end
    if self.in_between_piece(start_pos, end_pos).color == piece.color
      raise "You can't jump over one of your own pieces"
    end
    if self.in_between_piece(start_pos, end_pos).nil?
      raise "There's no piece to jump over!"
    end
    @grid[end_pos[0]][end_pos[1]] = self[start_pos[0], start_pos[1]]
    self[start_pos[0], start_pos[1]].position = [end_pos[0], end_pos[1]]  
    @grid[start_pos[0]][start_pos[1]] = nil
    @grid[in_between_square[0]][in_between_square[1]] = nil
    if piece.color == :black && end_pos[0] == 0
      piece.now_a_king
    elsif piece.color == :red && end_pos[0] == 7
      piece.now_a_king
    end
  end 

  def in_between_square(start_pos, end_pos)
    x = (end_pos[0] > start_pos[0] ? start_pos[0] + 1 : start_pos[0] - 1 )
    y = (end_pos[1] > start_pos[1] ? start_pos[1] + 1 : start_pos[1] - 1 )
    [x, y]
  end 

  def in_between_piece(start_pos, end_pos)
    x = (end_pos[0] > start_pos[0] ? start_pos[0] + 1 : start_pos[0] - 1 )
    y = (end_pos[1] > start_pos[1] ? start_pos[1] + 1 : start_pos[1] - 1 )
    self[x, y]
  end
  
  # def valid_move?(start_pos, end_pos)
#     if piece_at(end_pos)
#       # Change to another error?
#       return false
#     end
#   end 
  
  def show_board
      @grid.each_with_index do |row, row_index|
      row.each_with_index do |square, col_index|
        piece = self[row_index, col_index]
        if row_index.even? && col_index.even?
          print " #{piece.display} ".colorize( :color => :black, :background => :white ) if (piece && piece.color == :black)
          print " #{piece.display} ".colorize( :color => :red, :background => :white ) if (piece && piece.color == :red)
          print "   ".colorize( :background => :white ) if piece.nil?
        elsif row_index.even? && col_index.odd? 
          print " #{piece.display} ".colorize( :color => :black, :background => :light_white ) if (piece && piece.color == :black)
          print " #{piece.display} ".colorize( :color => :red, :background => :light_white ) if (piece && piece.color == :red)
          print "   ".colorize( :background => :light_white ) if piece.nil?
        elsif row_index.odd? && col_index.even? 
          print " #{piece.display} ".colorize( :color => :black, :background => :light_white ) if (piece && piece.color == :black)
          print " #{piece.display} ".colorize( :color => :red, :background => :light_white ) if (piece && piece.color == :red)
          print "   ".colorize( :background => :light_white ) if piece.nil?
        elsif row_index.odd? && col_index.odd?
          print " #{piece.display} ".colorize( :color => :black, :background => :white ) if (piece && piece.color == :black)
          print " #{piece.display} ".colorize( :color => :red, :background => :white ) if (piece && piece.color == :red)
          print "   ".colorize( :background => :white ) if piece.nil?
        end
      end
      puts ""
    end
  end
end
