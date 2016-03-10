
require 'benchmark'

class Maze::Algorithm
  attr_reader :duration
  
  def on grid
    @duration = Benchmark.realtime do
      work grid do |cell|
        yield cell if block_given?
      end
    end
    grid
  end
  
  def speed
    0.06
  end
  
  autoload :AldousBorder, 'maze/algorithm/aldous_border'
  autoload :AldousBorder2, 'maze/algorithm/aldous_border2'
  autoload :BinaryTree, 'maze/algorithm/binary_tree'
  autoload :Sidewinder, 'maze/algorithm/sidewinder'
  autoload :GrowingTree, 'maze/algorithm/growing_tree'
end