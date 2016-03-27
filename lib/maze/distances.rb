
class Maze::Distances
  
  def initialize root
    @root = root
    @cells = {}
    @cells[root] = 0
  end
  
  def [] cell
    @cells[cell]
  end
  
  def []= cell, distance
    @cells[cell] = distance
  end
  
  def cells
    @cells.keys
  end
  
  def path_to goal
    current = goal
    breadcrumbs = Maze::Distances.new @root
    breadcrumbs[current] = @cells[current]
    
    until current == @root
      current.links.each do |neighbor|
        if @cells[neighbor] < @cells[current]
          breadcrumbs[neighbor] = @cells[neighbor]
          current = neighbor
          break
        end 
      end
    end
    
    breadcrumbs
  end
end