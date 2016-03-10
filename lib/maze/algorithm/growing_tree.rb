

class Maze::Algorithm::GrowingTree < Maze::Algorithm
  
  # 1. Let C be a list of cells, initially empty. Add one cell to C, at random.
  # 2. Choose a cell from C, and carve a passage to any unvisited neighbor of that cell, adding that neighbor to C as well. If there are no unvisited neighbors, remove the cell from C.
  # 3. Repeat #2 until C is empty.
  
  def work grid
    cells = []
    visited = {}
    
    cell = grid.random_cell
    cells << cell
    
    until cells.empty?
      cell = cells.last
      visited[cell] = true

      neighbors = cell.neighbors.dup
      
      candidate = nil
      until neighbors.empty?
        candidate = neighbors.delete(neighbors.sample)
        break unless visited.key? candidate
        candidate = nil
      end
      
      if candidate
        cell.link candidate
        cells << candidate
      else
        cells.delete cell
      end
      
      yield cells
    end
  end
  
  def status
    "Growing tree algorithm: #{duration}s"
  end
end