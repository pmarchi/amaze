
require 'benchmark'

class Maze::Algorithm
  attr_reader :duration
  
  def on grid
    @duration = Benchmark.realtime do
      work grid
    end
    grid
  end
  
  autoload :AldousBorder, 'maze/algorithm/aldous_border'
  autoload :BinaryTree, 'maze/algorithm/binary_tree'
end