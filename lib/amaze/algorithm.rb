
require 'benchmark'

class Amaze::Algorithm
  class << self
    @@registred = {}

    def register name, options={}
      @@registred[name.to_sym] = {class: self, options: options}
    end
  
    def registred
      @@registred
    end
  
    def create name
      stored = @@registred[name]
      algorithm = stored[:class].new
      algorithm.options = stored[:options] unless stored[:options].empty?
      algorithm
    end
    
    def all
      @@registred.keys
    end
  end
  
  # Options can be defined on registration and will be set by create
  attr_accessor :options
  
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
end

require 'amaze/algorithm/aldous_border'
require 'amaze/algorithm/binary_tree'
require 'amaze/algorithm/sidewinder'
require 'amaze/algorithm/growing_tree'
require 'amaze/algorithm/wilson'
require 'amaze/algorithm/hunt_and_kill'
require 'amaze/algorithm/recursive_backtracker'
