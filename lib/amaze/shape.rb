
class Amaze::Shape
  
  def self.label label
    # register the class by its label
    (@@shapes ||= {})[label] = self
  end

  def self.all
    @@shapes.keys
  end
  
  def self.create label, size
    @@shapes[label].new size
  end
  
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
