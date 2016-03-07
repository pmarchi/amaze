
class Maze::Algorithm::AldousBorder < Maze::Algorithm
  
  def initialize
    @iterations = 0
  end
  
  def work grid
    cell = grid.random_cell
    unvisited = grid.size - 1

    while unvisited > 0
      neighbor = cell.neighbors.sample
  
      if neighbor.links.empty?
        cell.link neighbor
        unvisited -= 1
      end
  
      cell = neighbor
      @iterations += 1
    end
  end
  
  def status
    "Aldous-Border algorithm: #{@iterations} iterations in #{duration}s"
  end
end