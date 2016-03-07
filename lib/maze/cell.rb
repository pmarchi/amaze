
class Maze::Cell
  
  # The position of the cell in the grid
  attr_reader :row, :column
  
  # The neighbor cells
  attr_accessor :north, :east, :south, :west
  
  # Links (Path) to other cells
  attr_reader :links
  
  def initialize row, column
    @row = row
    @column = column
    
    @links = {}
  end
  
  def neighbors
    [north, east, south, west].compact
  end
  
  def link cell, bidi=true
    links[cell] = true
    cell.link self, false if bidi
  end
  
  def linked? cell
    links.key? cell
  end
  
  def inspect
    "cell(#{row},#{column})"
  end
end