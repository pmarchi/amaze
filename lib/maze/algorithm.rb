
require 'benchmark'

class Maze::Algorithm
  
  # Helper class to report the status of the algorithm
  class Stat
    def initialize opts
      @current = opts[:current]
      @pause = opts[:pause]
      @info = opts[:info]
    end

    attr_reader :current, :info
  
    def pause?
      @pause
    end
  end
    
  # The time the algorithm takes to generate the maze
  attr_reader :duration
  
  def on grid
    @duration = Benchmark.realtime do
      work grid do |stat|
        yield stat if block_given?
      end
    end
    grid
  end
  
  def speed
    0.06
  end
    
  autoload :AldousBorder, 'maze/algorithm/aldous_border'
  autoload :BinaryTree, 'maze/algorithm/binary_tree'
  autoload :Sidewinder, 'maze/algorithm/sidewinder'
  autoload :GrowingTree, 'maze/algorithm/growing_tree'
  autoload :Wilson, 'maze/algorithm/wilson'
  autoload :HuntAndKill, 'maze/algorithm/hunt_and_kill'
  autoload :RecursiveBacktracker, 'maze/algorithm/recursive_backtracker'
end
