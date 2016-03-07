
class Maze::Cell
  
  # The position of the cell in the grid
  attr_reader :row, :column
  
  # The neighbor cells
  attr_accessor :north, :east, :south, :west
  
  def initialize row, column
    @row = row
    @column = column
  end
  
  def neighbors
    [north, east, south, west].compact
  end
end