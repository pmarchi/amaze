
class Maze::Shape
  autoload :Triangle, 'maze/shape/triangle'
  autoload :Diamond, 'maze/shape/diamond'
  autoload :Hexagon, 'maze/shape/hexagon'
  autoload :Star, 'maze/shape/star'
  
  # The size of the shape, usually the rows
  attr_reader :size
  
  def initialize size
    @size = size
  end
  
  def mask
    @mask ||= Maze::Mask.new rows, columns
  end
  
  def create_mask
    build_mask
    mask
  end
end