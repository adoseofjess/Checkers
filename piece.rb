# require 'debugger'
require './board'

class Piece
  attr_accessor :color, :king, :position, :display, :board

  def initialize(color, position, board)
    @color = color
    @king = false
    @position = position
    @display = "O"
    @board = board
  end
  
  def now_a_king
    @king = true
    @display = "K"
  end
  
  def slide_move_dir
    if @king == false
      if @color == :red
        move_dir = [[1,-1], [1,1]]
      elsif @color == :black
        move_dir = [[-1,-1], [-1,1]] 
      end
    else
      move_dir = [[-1,1], [-1,1], [1,-1], [1,1]]
    end
  end
  
  def slide_moves
    all_slide_destinations = slide_move_dir.map { |coord| [self.position[0] + coord[0], self.position[1] + coord[1]] }
    on_board?(all_slide_destinations)
  end
  
  def jump_move_dir
    if @king == false
      if @color == :red
        move_dir = [[2,-2], [2,2]]
      elsif @color == :black
        move_dir = [[-2,-2], [-2,2]] 
      end
    else
      move_dir = [[-2,2], [-2,2], [2,-2], [2,2]]
    end
  end
  
  def jump_moves
    all_jump_destinations = jump_move_dir.map { |coord| [self.position[0] + coord[0], self.position[1] + coord[1]] }
    on_board?(all_jump_destinations)
  end
  
  def on_board?(destinations)
    destinations.select { |coordinates| coordinates.all? { |point| point >= 0 && point <= 7 } }
  end
  
  def perform_moves!(*move_sequence)
    if is_a_slide?(move_sequence.first)
      self.board.perform_slide(self.position, move_sequence.first)
    end
    
    if is_a_jump?(move_sequence.first)
      # debugger
      move_sequence.each do |destination|
        self.board.perform_jump(self.position, destination)
      end
    end
  end
  
  def is_a_slide?(end_pos)
    start_pos = self.position
    return true if (end_pos[0]-start_pos[0]).abs == 1 && (end_pos[1]-start_pos[1]).abs == 1
  end
  
  def is_a_jump?(end_pos)
    start_pos = self.position
    return true if (end_pos[0]-start_pos[0]).abs == 2 && (end_pos[1]-start_pos[1]).abs == 2
  end
end

board = Board.new
board.perform_slide([2,0], [3,1])
board.perform_slide([3,1], [4,2])
board.perform_slide([1,1], [2,0])
board[5,1].perform_moves!([3,3], [1,1])
board.perform_slide([1,3], [2,2])
board.perform_slide([0,2], [1,3])
board.perform_slide([1,1], [0,2])
board.show_board