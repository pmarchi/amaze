
require 'chunky_png'

class Maze::Formatter::PNG
  autoload :Ortho, 'maze/formatter/png/ortho'
  
  # The size of a sigle cell in pixel
  attr_reader :cell_size
  
  # The border around the maze in pixel
  attr_reader :border
  
  # The thickness of the lines
  attr_reader :line_width
  
  def initialize options={}
    @cell_size = options.fetch(:cell_size, 10)
    @border = options.fetch(:border, 0)
    @line_width = options.fetch(:line_width, 1) / 2 * 2 + 1 # only odd numbers!
  end
end