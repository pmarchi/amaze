
class Maze::Cell
  autoload :Square, 'maze/cell/square'
  autoload :Hex, 'maze/cell/hex'
  
  # The position of the cell in the grid
  attr_reader :row, :column
  
  # Links (Path) to other cells
  attr_reader :links
  
  def initialize row, column
    @row = row
    @column = column
    
    @links = {}
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
  
  def to_s
    "(#{row},#{column})"
  end
end