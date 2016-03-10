
class Maze::Algorithm::GrowingTree < Maze::Algorithm
  
  def initialize
    @select = Proc.new {|active| active.last }
  end
  
  def select
    @select = Proc.new  # implicit conversion of passed block
  end
  
  def work grid
    active = [grid.random_cell]
    
    while active.any?
      cell = @select.call active
      
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