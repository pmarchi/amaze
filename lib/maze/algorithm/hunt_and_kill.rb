
class Maze::Algorithm::HuntAndKill < Maze::Algorithm
  
  def work grid
    
    current = grid.random_cell
    path = [] # visualize
    
    while current
      unvisited_neighbors = current.neighbors.select {|c| c.links.empty? }

      path << current                               # visualize
      yield Stat.new(                               #
        current: path,                              #
        pause: unvisited_neighbors.empty?,          #
        info: "Path: #{path.size}") if block_given? #

      # carve path
      if unvisited_neighbors.any?
        neighbor = unvisited_neighbors.sample
        current.link neighbor
        current = neighbor
        
      # hunt
      else
        current = nil

        path = [] # visualize
        hunt = 0  #

        grid.each_cell do |cell|
          visited_neighbors = cell.neighbors.select {|c| c.links.any? }

          yield Stat.new(                                       # visualize
            current: [cell],                                    #
            pause: cell.links.empty? && visited_neighbors.any?, #
            info: "Hunt: #{hunt += 1}") if block_given?         #

          if cell.links.empty? && visited_neighbors.any?
            current = cell
            neighbor = visited_neighbors.sample
            current.link neighbor
            break
          end
        end
      end
    end
  end
  
  def status
    "Hunt and Kill algorithm: #{duration}s"
  end
end