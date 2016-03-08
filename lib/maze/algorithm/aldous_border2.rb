
class Maze::Algorithm::AldousBorder2 < Maze::Algorithm
  
  def initialize
    @iterations = 0
  end
  
  def work grid
    cell = grid.random_cell
    unvisited = grid.size - 1

    while unvisited > 0
      neighbor = cell.neighbors.sample
  
      if neighbor.links.empty?
        yield cell if block_given?
        cell.link neighbor
        unvisited -= 1
      end

      cell = neighbor
      @iterations += 1
    end
  end
    
  def status
    "Aldous-Border 2 algorithm: #{@iterations} iterations in #{duration}s"
  end
end