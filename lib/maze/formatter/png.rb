
# require 'chunky_png'
require 'oily_png'
require 'gradient'

class Maze::Formatter::PNG
  autoload :Ortho, 'maze/formatter/png/ortho'
  
  # The grid
  attr_reader :grid
  
  # Options for the PNG renderer
  attr_reader :options
  
  def initialize grid, options={}
    @grid = grid
    @options = options
  end
  
  def cell_size
    @options[:cell_size] || 10
  end
  
  def border
    @options[:border] || 0
  end
  
  def line_width
    (@options[:line_width] || 1) / 2 * 2 + 1 # only odd numbers!
  end

  def background_color
    ChunkyPNG::Color::WHITE
  end
  
  def wall_color
    ChunkyPNG::Color.html_color(@options[:line_color] || :black)
  end

  def distances
    options[:distances]
  end
  
  def distances_max
    @distances_max ||= distances.max[1]
  end
  
  # Returns the background color of a cell, depending on its distance from the origin
  def background_color_for cell
    if distances && distances[cell]
      color_at distances[cell]
    else
      nil
    end
  end
  
  def color_at distance
    intensity = (distances_max - distance.to_f) / distances_max
    ChunkyPNG::Color.from_hex(gradient.at(intensity).color.hex)
  end
  
  def gradient
    # @gradient ||= Gradient::Map.new(
    #   Gradient::Point.new(0,    Color::RGB.new(  0,   0,   0), 1.0), # blue
    #   Gradient::Point.new(1,    Color::RGB.new(255, 255, 255), 1.0), # white
    # )
    @gradient ||= Gradient::Map.new(
      Gradient::Point.new(0,    Color::RGB.new(  0,   0, 128), 1.0), # blue
      Gradient::Point.new(0.6,  Color::RGB.new(  0, 191, 255), 1.0), # cyan
      Gradient::Point.new(1,    Color::RGB.new(255, 255, 255), 1.0), # white
    )
    # @gradient ||= Gradient::Map.new(
    #   Gradient::Point.new(0,    Color::RGB.new(128,   0,   0), 1.0), # dark red
    #   Gradient::Point.new(0.5,  Color::RGB.new(255, 128,   0), 1.0), # light red yellow
    #   Gradient::Point.new(0.75, Color::RGB.new(255, 255,   0), 1.0), # yellow
    #   Gradient::Point.new(1,    Color::RGB.new(255, 255, 255), 1.0), # white
    # )
  end
end