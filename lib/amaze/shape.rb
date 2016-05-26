
class Amaze::Shape
  extend Amaze::Module::AutoRegisterSubclass
  
  # The size of the shape, usually the rows
  attr_reader :size
  
  def initialize size
    @size = size
  end
  
  def on count
    Array.new(count, '.')
  end
  
  def off count
    Array.new(count, 'X')
  end
  
  def to_s
    chars.map {|l| l.join }.join("\n")
  end
end

require 'amaze/shape/triangle'
require 'amaze/shape/diamond'
require 'amaze/shape/hexagon'
require 'amaze/shape/star'
require 'amaze/shape/cross'
