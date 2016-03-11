
class Maze::Algorithm::GrowingTree < Maze::Algorithm
  
  # The configuration of the algorithm
  # In this instance the way the next cell gets picked
  # from the list of active cells.
  attr_reader :config
  
  def initialize
    @config = Proc.new {|active| active.last }
  end
  
  def configure block
    @config = block
  end
  
  def work grid
    active = [grid.random_cell]
    
    while active.any?
      cell = config.call active
      
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