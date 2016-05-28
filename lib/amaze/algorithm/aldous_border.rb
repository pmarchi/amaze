
class Amaze::Algorithm::AldousBorder < Amaze::Algorithm
  
  register :ab
  
  def work grid
    cell = grid.random_cell
    unvisited = grid.size - 1

    @iterations = 0 # visualize
    pause = true    #

    while unvisited > 0

      yield Stat.new(                                           # visualize
        current: [cell],                                        #
        pause: pause,                                           #
        info: "Iteration: #{@iterations += 1}") if block_given? #
      pause = false                                             #

      neighbor = cell.neighbors.sample
      
      if neighbor.links.empty?
        pause = true    # visualize
        cell.link neighbor
        unvisited -= 1
      end

      cell = neighbor

    end
    grid
  end
  
  def status
    "Aldous-Border algorithm: #{@iterations} iterations in #{duration}s"
  end
end