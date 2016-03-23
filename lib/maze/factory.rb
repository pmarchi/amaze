
class Maze::Factory
  
  def self.types
    %i( delta ortho sigma )
  end
  
  # The type of the grid
  attr_reader :type
  
  def initialize type
    raise "#{type} maze is not supported" unless self.class.types.include? type
    @type = type
  end
  
  def create_grid *args
    Maze::Grid.const_get(type.to_s.capitalize).new *args
  end
  
  def create_ascii_formatter *args
    Maze::Formatter::ASCII.const_get(type.to_s.capitalize).new *args
  end
end