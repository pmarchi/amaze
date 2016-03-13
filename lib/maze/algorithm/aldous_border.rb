
class Maze::Algorithm::AldousBorder < Maze::Algorithm
  
  def initialize
    @iterations = 0
  end
  
  def work grid
    cell = grid.random_cell
    unvisited = grid.size - 1

    while unvisited > 0
      @iterations += 1
      neighbor = cell.neighbors.sample
      
      stat.active = [cell]
      stat.info = "Iteration: #{@iterations}"
      yield stat if block_given?
      stat.segment = neighbor.links.empty?

      if neighbor.links.empty?
        cell.link neighbor
        unvisited -= 1
      end
  
      cell = neighbor
    end
    grid
  end
  
  def speed
    0.02
  end
  
  def status
    "Aldous-Border algorithm: #{@iterations} iterations in #{duration}s"
  end
end