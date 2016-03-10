
class Maze::Algorithm::GrowingTree < Maze::Algorithm
  
  def work grid
    active = [grid.random_cell]
    
    while active.any?
      
      # selecting the last element is recursive backtracker
      # choose whatever you want
      # cell = (rand(3) == 0) ? active.sample : active.last
      # cell = active[active.size/2..-1].sample
      cell = active.last
      
      neighbor = cell.neighbors.select {|neighbor| neighbor.links.empty? }.sample
      
      if neighbor
        cell.link neighbor
        active << neighbor
      else
        active.delete cell
      end
      
      yield active
    end
    
    grid
  end
  
  def status
    "Growing tree algorithm: #{duration}s"
  end
end