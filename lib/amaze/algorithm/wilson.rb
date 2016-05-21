
class Amaze::Algorithm::Wilson < Amaze::Algorithm
  
  def work grid
    
    # initialize
    unvisited = []
    grid.each_cell {|cell| unvisited << cell }
    
    # pick randon cell and remove from unvisited
    start = unvisited.sample
    unvisited.delete start
    
    while unvisited.any?
      cell = unvisited.sample
      path = [cell]
      
      # loop erased walk
      while unvisited.include? cell
        cell = cell.neighbors.sample

        if path.include? cell
          path = path[0..path.index(cell)]
        else
          path << cell
        end

        yield Stat.new(                                   # visualize
          current: [start, *path].compact,                #
          pause: ! unvisited.include?(cell),              #
          info: "Path: #{path.size}") if block_given?     #

      end
      
      # carve path
      carved = 0                                          # visualize
      path.each_cons(2) do |cell1, cell2|
        cell1.link cell2
        unvisited.delete cell1
        
        yield Stat.new(                                   # visualize
          current: path,                                  #
          pause: cell2 == path.last,                      #
          info: "Carved: #{carved += 1}") if block_given? #

      end
      start = nil                                         # visualize
    end
  end
  
  def status
    "Wilson algorithm: #{duration}s"
  end
end