
class Maze::Algorithm::RecursiveBacktracker < Maze::Algorithm
  
  def work grid, &block
    carve [grid.random_cell], &block
  end
  
  def carve path, &block
    current = path.last

    while current
      unvisited_neighbors = current.neighbors.select {|c| c.links.empty? }

      yield Stat.new(                               # visualize
        current: path,                              #
        pause: segmentend?(unvisited_neighbors),    #
        info: "Path: #{path.size}") if block_given? #

      if unvisited_neighbors.any?
        neighbor = unvisited_neighbors.sample
        current.link neighbor
        carve [*path, neighbor], &block
      else
        current = nil
      end
    end
  end
  
  def segmentend? unvisited_neighbors
    @forward = true if @forward.nil?
    if unvisited_neighbors.empty? && @forward || unvisited_neighbors.any? && !@forward
      @forward = !@forward
      true
    else
      false
    end
  end

  def status
    "Recursive Backtracker algorithm: #{duration}s"
  end
end