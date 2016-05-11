
require 'gradient'

class Maze::Factory

  # All known maze types
  def self.types
    %i( delta ortho sigma upsilon )
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
  
  def create_masked_grid file
    klass = Maze::Grid.const_get(type.to_s.capitalize)
    klass.prepend Maze::MaskedGrid
    klass.new create_mask(file)
  end
  
  def create_mask file
    case File.extname file
    when '.txt'
      Maze::Mask.from_txt file
    when '.png'
      Maze::Mask.from_png file
    else
      raise "Mask file of type #{File.extname(file)} is not supported."
    end
  end
  
  def create_ascii_formatter *args
    Maze::Formatter::ASCII.const_get(type.to_s.capitalize).new *args
  end

  def create_png_formatter *args
    Maze::Formatter::PNG.const_get(type.to_s.capitalize).new *args
  end

  # All known algorithms
  def self.algorithms
    %i( bt sw ab gt1 gt2 gt3 gt4 w hk rb )
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
      w:   Maze::Algorithm::Wilson,
      hk:  Maze::Algorithm::HuntAndKill,
      rb:  Maze::Algorithm::RecursiveBacktracker,
    }
    
    # Algorithms only for ortho mazes
    select.merge!(
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
  
  def self.gradient_maps
    %i( red green blue monochrome cold warm gold )
  end
  
  def gradient_map name=:green
    { red:
        Gradient::Map.new(
          Gradient::Point.new(0, Color::RGB.new( 95,   0,   0), 1.0), # dark red
          Gradient::Point.new(1, Color::RGB.new(255, 255, 255), 1.0), # white
        ),
      green:
        Gradient::Map.new(
          Gradient::Point.new(0, Color::RGB.new(  0,  95,   0), 1.0), # dark green
          Gradient::Point.new(1, Color::RGB.new(255, 255, 255), 1.0), # white
        ),
      blue:
        Gradient::Map.new(
          Gradient::Point.new(0, Color::RGB.new(  0,   0,  95), 1.0), # dark blue
          Gradient::Point.new(1, Color::RGB.new(255, 255, 255), 1.0), # white
        ),
      monochrome: 
        Gradient::Map.new(
          Gradient::Point.new(0, Color::RGB.new(  0,   0,   0), 1.0), # black
          Gradient::Point.new(1, Color::RGB.new(255, 255, 255), 1.0), # white
        ),
      cold: 
        Gradient::Map.new(
          Gradient::Point.new(0,    Color::RGB.new(  0,   0,  95), 1.0), # blue
          Gradient::Point.new(0.65, Color::RGB.new(  0, 191, 255), 1.0), # cyan
          Gradient::Point.new(1,    Color::RGB.new(255, 255, 255), 1.0), # white
        ),
      warm: 
        Gradient::Map.new(
          Gradient::Point.new(0,    Color::RGB.new( 95,   0,   0), 1.0), # dark red
          Gradient::Point.new(0.65, Color::RGB.new(255, 191,   0), 1.0), # yellow
          Gradient::Point.new(1,    Color::RGB.new(255, 255, 255), 1.0), # white
        ),
      gold:
        Gradient::Map.new(
          Gradient::Point.new(0,    Color::RGB.new(128,   0,   0), 1.0), # dark red
          Gradient::Point.new(0.5,  Color::RGB.new(255, 128,   0), 1.0), # light red yellow
          Gradient::Point.new(0.75, Color::RGB.new(255, 255,   0), 1.0), # yellow
          Gradient::Point.new(1,    Color::RGB.new(255, 255, 255), 1.0), # white
        ),
    }[name]
  end
end