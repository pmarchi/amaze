
class Amaze::Algorithm::RecursiveBacktracker < Amaze::Algorithm
  
  def initialize
    @implementation = :stack
  end
  
  def configure implementation
    @implementation = implementation
  end
  
  def work grid, &block
    case @implementation
    when :recursion
      carve [grid.random_cell], &block
    when :stack
      work_with_stack [grid.random_cell], &block
    end
  end

  # implementation with explicit stack
  def work_with_stack stack, &block
    while stack.any?
      current = stack.last
      unvisited_neighbors = current.neighbors.select {|c| c.links.empty? }

      yield Stat.new(                                # visualize
        current: stack,                              #
        pause: segment?(unvisited_neighbors),        #
        info: "Path: #{stack.size}") if block_given? #
      
      if unvisited_neighbors.any?
        neighbor = unvisited_neighbors.sample
        current.link neighbor
        stack << neighbor
      else
        stack.pop
      end
    end
  end
  
  # implementation with recursion
  def carve path, &block
    current = path.last

    while current
      unvisited_neighbors = current.neighbors.select {|c| c.links.empty? }

      yield Stat.new(                               # visualize
        current: path,                              #
        pause: segment?(unvisited_neighbors),       #
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
  
  def segment? unvisited_neighbors
    @forward = true if @forward.nil?
    if unvisited_neighbors.empty? && @forward || unvisited_neighbors.any? && !@forward
      @forward = !@forward
      true
    else
      false
    end
  end

  def status
    "Recursive Backtracker (#{@implementation}) algorithm: #{duration}s"
  end
end