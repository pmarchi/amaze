
# require 'chunky_png'
require 'oily_png'

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
    @options[:line_width] || 1
  end

  def background_color
    ChunkyPNG::Color.html_color(@options[:background_color] || :white)
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
    options[:gradient_map]
  end
  
  def self.colors
    ChunkyPNG::Color::PREDEFINED_COLORS.keys
  end
end