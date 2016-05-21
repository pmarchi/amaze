
class Amaze::Cell::Hex < Amaze::Cell
  
  # The neighbor cells
  attr_accessor :north, :northeast, :southeast, :south, :northwest, :southwest
  
  def neighbors
    [north, northeast, southeast, south, northwest, southwest].compact
  end
end