
class Maze::Algorithm::HuntAndKill < Maze::Algorithm
  
  def work grid
    
    current = grid.random_cell
    path = []                                     # visualize
    
    while current
      unvisited_neighbors = current.neighbors.select {|c| c.links.empty? }
      
      path << current                             # visualize
      stat.active = path                          #
      stat.info = "Path: #{path.size}"            #
      stat.segment = unvisited_neighbors.empty?   #
      yield stat if block_given?                  #

      # carve path
      if unvisited_neighbors.any?
        neighbor = unvisited_neighbors.sample
        current.link neighbor
        current = neighbor
        
      # hunt
      else
        current = nil

        path = []                                 # visualize
        hunt = 0                                  # visualize

        grid.each_cell do |cell|

          hunt += 1                               # visualize
          stat.active = [cell]                    #
          stat.info = "Hunt: #{hunt}"             #
          stat.segment = false                    #
          yield stat if block_given?              #

          visited_neighbors = cell.neighbors.select {|c| c.links.any? }
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