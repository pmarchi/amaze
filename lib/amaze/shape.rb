
class Amaze::Shape
  autoload :Triangle, 'amaze/shape/triangle'
  autoload :Diamond, 'amaze/shape/diamond'
  autoload :Hexagon, 'amaze/shape/hexagon'
  autoload :Star, 'amaze/shape/star'
  
  # The size of the shape, usually the rows
  attr_reader :size
  
  def initialize size
    @size = size
  end
  
  def mask
    @mask ||= Amaze::Mask.new rows, columns
  end
  
  def create_mask
    build_mask
    mask
  end
end