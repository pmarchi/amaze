
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
    # true when active gets cells added
    # false when active gets cells deleted
    prev_mode = true

    active = [grid.random_cell]
    
    while active.any?
      cell = config.call active
      
      neighbor = cell.neighbors.select {|neighbor| neighbor.links.empty? }.sample
      
      mode = !!neighbor
      stat.active = active
      stat.segment = prev_mode ^ mode
      yield stat if block_given?
      prev_mode = mode
      
      if neighbor
        cell.link neighbor
        active << neighbor
      else
        active.delete cell
      end
      
    end
    
    grid
  end
  
  def status
    "Growing tree algorithm: #{duration}s"
  end
end