
class Maze::Factory

  # All known maze types
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

  def create_png_formatter *args
    Maze::Formatter::PNG.const_get(type.to_s.capitalize).new *args
  end

  # All known algorithms
  def self.algorithms
    %i( bt sw ab gt1 gt2 gt3 gt4 )
  end
  
  def create_algorithm algorithm
    raise "#{algorithm} is not supported" unless self.class.algorithms.include? algorithm
    
    # Alogrithms for all mazes
    select = {
      ab:  Maze::Algorithm::AldousBorder,
      gt1: Maze::Algorithm::GrowingTree,
      gt2: Maze::Algorithm::GrowingTree,
      gt3: Maze::Algorithm::GrowingTree,
      gt4: Maze::Algorithm::GrowingTree,
    }
    
    # Algorithms only for ortho mazes
    select.merge(
      bt: Maze::Algorithm::BinaryTree,
      sw: Maze::Algorithm::Sidewinder
    ) if type == :ortho
    
    raise "Alogrithm not supported on #{type} maze." unless select[algorithm]
    instance = select[algorithm].new

    case algorithm
    when :gt1
      instance.configure "last from list", proc {|active| active.last }
    when :gt2
      instance.configure "random from list", proc {|active| active.sample }
    when :gt3
      instance.configure "last/random 1/1 from list", proc {|active| (rand(2) > 0) ? active.last : active.sample }
    when :gt4
      instance.configure "last/random 2/1 from list", proc {|active| (rand(3) > 0) ? active.last : active.sample }
    end
    
    instance 
  end
end