
require 'rmagick'

class Maze::Formatter::Image
  autoload :Ortho, 'maze/formatter/image/ortho'
  autoload :Sigma, 'maze/formatter/image/sigma'
  autoload :Polar, 'maze/formatter/image/polar'
  
  # The grid
  attr_reader :grid
  
  # Options for the Image renderer
  attr_reader :options
  
  def initialize grid, options={}
    @grid = grid
    @options = options
  end
  
  def path? direction, cell
    cell.linked?(cell.send(direction)) && path_cell?(cell.send(direction))
  end
  
  def path_cell? cell
    path_cells.include? cell
  end
  
  def path_cells
    Array(options[:path_cells])
  end
  
  def path_start
    options[:path_start]
  end
  
  def path_finish
    options[:path_finish]
  end
  
  def render
    render_background if distances
    render_grid if show_grid?
    render_wall unless hide_walls?
    render_path if path_cells.any?
  end
  
  def image
    @image ||= Magick::Image.new image_width, image_height, Magick::SolidFill.new(background_color)
  end
  
  def canvas
    @canvas ||= Magick::Draw.new
  end
  
  def write filename
    canvas.draw image
    image.write(filename)
  end
  
  def cell_width
    @options[:cell_width] || 100
  end
  
  def border_width
    @options[:border_width] || 0
  end
  
  def wall_width
    @options[:wall_width] || 5
  end

  def wall_color
    @options[:wall_color].to_s || 'black'
  end

  def path_width
    @options[:path_width] || 3
  end

  def path_color
    @options[:path_color].to_s || 'red'
  end

  def background_color
    @options[:background_color].to_s || 'white'
  end
  
  def show_grid?
    @options[:show_grid]
  end
  
  def hide_walls?
    @options[:hide_walls]
  end
  
  def distances
    options[:distances]
  end

  def distances_max
    @distances_max ||= distances.max[1]
  end
  
  # Returns the background color of a cell, depending on its distance from the origin
  def distance_color cell
    if distances && distances[cell]
      intensity = (distances_max - distances[cell].to_f) / distances_max
      '#' + gradient.at(intensity).color.hex
    else
      nil
    end
  end
  
  def gradient
    options[:gradient_map]
  end
  
  def self.colors
    Magick.colors.map(&:name)
  end
end