
module Maze::DistancesModule

  # The distances from a given cell to all other cells in the grid
  attr_accessor :distances
  
  def contents_of cell
    if distances && distances[cell]
      distances[cell].to_s(36).upcase # 0..9a..z
    else
      " "
    end
  end
end