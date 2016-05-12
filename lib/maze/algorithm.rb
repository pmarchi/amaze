
require 'benchmark'

class Maze::Algorithm
  
  class Stat < Struct.new(:active, :segment, :info); end
  
  # The time the algorithm takes to generate the maze
  attr_reader :duration
  
  # The current stat of the algorithm
  def stat
    @stat ||= Stat.new([], true, false)
  end
  
  # TODO: Replace Stat with this
  #
  # class KeywordStruct < Struct
  #   def initialize(**kwargs)
  #     super(kwargs.keys)
  #     kwargs.each { |k, v| self[k] = v }
  #   end
  # end
  #
  # This will allow to consturct the stat object within the algorithm like this
  # Stat.new(active: [], pause: false, info: "This is an info.")
  
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