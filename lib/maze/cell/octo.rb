
class Maze::Cell::Octo < Maze::Cell
  
  # The neighbor cells
  attr_accessor :north, :northeast, :east, :southeast, :south, :northwest, :west, :southwest
  
  def neighbors
    [north, northeast, east, southeast, south, northwest, west, southwest].compact
  end
end