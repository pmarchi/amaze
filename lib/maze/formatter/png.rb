
require 'chunky_png'

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

  def distances
    options[:distances]
  end
  
  def distances_max
    @distances_max ||= distances.max[1]
  end
  
  # Returns the background color of a cell, depending on its distance from the origin
  def background_color_for cell
    if distances && distances[cell]
      intensity = (distances_max - distances[cell]).to_f / distances_max
      dark = (255 * intensity).round
      bright = 96 + (159 * intensity).round
      ChunkyPNG::Color.rgb(bright, dark, dark)
    else
      nil
    end
  end
end