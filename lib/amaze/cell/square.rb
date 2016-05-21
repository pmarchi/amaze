
class Amaze::Cell::Square < Amaze::Cell
  
  # The neighbor cells
  attr_accessor :north, :east, :south, :west
  
  def neighbors
    [north, east, south, west].compact
  end
end