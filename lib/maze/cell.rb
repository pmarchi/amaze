
class Maze::Cell
  autoload :Square, 'maze/cell/square'
  autoload :Hex, 'maze/cell/hex'
  
  # The position of the cell in the grid
  attr_reader :row, :column
  
  def initialize row, column
    @row = row
    @column = column
    
    @links = {}
  end
  
  def links
    @links.keys
  end
  
  def link cell, bidi=true
    @links[cell] = true
    cell.link self, false if bidi
  end
  
  def linked? cell
    @links.key? cell
  end
  
  def inspect
    "cell(#{row},#{column})"
  end
  
  def to_s
    "(#{row},#{column})"
  end
  
  def distances
    distances = Maze::Distances.new self
    frontier = [self]
    
    while frontier.any?
      new_frontier = []
      
      frontier.each do |cell|
        cell.links.each do |linked|
          next if distances[linked]
          distances[linked] = distances[cell] + 1
          new_frontier << linked
        end
      end
      
      frontier = new_frontier
    end
    
    distances
  end
end