
require 'rmagick'

class Maze::Formatter::Image
  autoload :Ortho, 'maze/formatter/image/ortho'
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
    render_background
    render_wall
    render_path
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
  
  def self.colors
    Magick.colors.map(&:name)
  end
end