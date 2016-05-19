
class Maze::Shape
  autoload :Triangle, 'maze/shape/triangle'
  
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