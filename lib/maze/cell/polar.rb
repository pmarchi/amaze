
class Maze::Cell::Polar < Maze::Cell
  
  # The neighbor cells
  attr_accessor :cw, :ccw, :inward
  attr_reader :outward
  
  def initialize(row, column)
    super
    @outward = []
  end
  
  def neighbors
    [cw, ccw, inward, *outward].compact
  end
end