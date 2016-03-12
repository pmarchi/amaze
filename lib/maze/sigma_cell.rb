
class Maze::SigmaCell < Maze::Cell
  
  # The additional neighbor cells
  attr_accessor :northeast, :southeast, :northwest, :southwest
  
  # The new neighbors, ignore east and west
  def neighbors
    [north, northeast, southeast, south, northwest, southwest].compact
  end
end