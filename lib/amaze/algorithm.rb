
require 'benchmark'

class Amaze::Algorithm
  
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
    
  autoload :AldousBorder, 'amaze/algorithm/aldous_border'
  autoload :BinaryTree, 'amaze/algorithm/binary_tree'
  autoload :Sidewinder, 'amaze/algorithm/sidewinder'
  autoload :GrowingTree, 'amaze/algorithm/growing_tree'
  autoload :Wilson, 'amaze/algorithm/wilson'
  autoload :HuntAndKill, 'amaze/algorithm/hunt_and_kill'
  autoload :RecursiveBacktracker, 'amaze/algorithm/recursive_backtracker'
end
