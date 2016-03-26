require 'colorize' # TODO: test rainbow as well

class Maze::Formatter::ASCII
  autoload :Delta, 'maze/formatter/ascii/delta'
  autoload :Ortho, 'maze/formatter/ascii/ortho'
  autoload :Sigma, 'maze/formatter/ascii/sigma'

  include Maze::DistancesModule
  
  # The grid
  attr_reader :grid
  
  # Options for the ASCII renderer
  attr_reader :options
  
  def initialize grid, options={}
    @grid = grid
    @options = options
  end
  
  def ansi_clear
    "\e[H\e[2J"
  end
  
  # The size of the cell
  def cell_size
    options[:cell_size] || 1
  end
  
  def highlighted_cell? cell
    Array(options[:highlighted_cells]).include? cell
  end
  
  def content_highlighted
    '*'
  end
  
  # Distances
  def distances
    options[:distances]
  end
end