
class Maze::Algorithm::Wilson < Maze::Algorithm
  
  def work grid
    
    # initialize
    unvisited = []
    grid.each_cell {|cell| unvisited << cell }
    
    # pick randon cell and remove from unvisited
    unvisited.delete unvisited.sample
    
    while unvisited.any?
      cell = unvisited.sample
      path = [cell]
      
      # loop erased walk
      while unvisited.include? cell
        cell = cell.neighbors.sample

        stat.active = path                          # visualize
        stat.info = "Cells in path: #{path.size}"   #
        stat.segment = ! unvisited.include?(cell)   #
        yield stat if block_given?                  #

        if path.include? cell
          path = path[0..path.index(cell)]
        else
          path << cell
        end
      end
      
      # carve path
      carved = [path.first]                          # visualize
      path.each_cons(2) do |cell1, cell2|
        cell1.link cell2
        unvisited.delete cell1
        
        carved << cell2                              # visualize
        stat.active = carved                         #
        stat.info = "Carved cells: #{carved.size}"   #
        stat.segment = carved.last == path.last      #
        yield stat if block_given?                   #
      end
    end
  end
  
  def status
    "Wilson algorithm: #{duration}s"
  end
end