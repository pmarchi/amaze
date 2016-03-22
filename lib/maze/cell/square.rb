
class Maze::Cell::Square < Maze::Cell
  
  # The neighbor cells
  attr_accessor :north, :east, :south, :west
  
  def neighbors
    [north, east, south, west].compact
  end
end