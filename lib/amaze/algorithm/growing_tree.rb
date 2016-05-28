
class Amaze::Algorithm::GrowingTree < Amaze::Algorithm
  
  register :gt1, 
    strategy: ->(active) { active.last }, 
    description: "last from list"

  register :gt2,
    strategy: ->(active) { active.sample },
    description: "random from list"
    
  register :gt3,
    strategy: ->(active) { (rand(2) > 0) ? active.last : active.sample },
    description: "last/1 : random/1 from list"

  register :gt4,
    strategy: ->(active) { (rand(3) > 0) ? active.last : active.sample },
    description: "last/2 : random/1 from list"
    
    
  def strategy
    options[:strategy]
  end
  
  def description
    options[:description]
  end
    
  def work grid
    # true when active gets cells added
    # false when active gets cells deleted
    mode = true

    active = [grid.random_cell]
    
    while active.any?
      cell = strategy.call active
      
      neighbor = cell.neighbors.select {|neighbor| neighbor.links.empty? }.sample
      
      yield Stat.new(                                  # visualize
        current: active,                               #
        pause: mode ^ !!neighbor,                      #
        info: "Active #{active.size}") if block_given? #
      mode = !!neighbor                                #
      
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
    "Growing tree (#{description}) algorithm: #{duration}s"
  end
end