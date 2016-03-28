require 'colorize' # TODO: test rainbow as well

class Maze::Formatter::ASCII
  autoload :Delta, 'maze/formatter/ascii/delta'
  autoload :Ortho, 'maze/formatter/ascii/ortho'
  autoload :Sigma, 'maze/formatter/ascii/sigma'

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
  
  def content_color_of cell
    if @options[:content_color].is_a? Hash
      @options[:content_color][cell]
    elsif @options[:content_color].is_a? Symbol
      @options[:content_color]
    else
      :blue
    end
  end

  def content_color
    @options[:content_color] || :blue
  end
  
  # Distances
  def distances
    options[:distances]
  end
  
  # Returns the content of a cell:
  # a) the cell is in the list of the cells to be highlighted => '*'
  # b) distances have been assigned, the current distance as 36 based integer, e.g. => '1F'
  # c) empty cell => ' '
  def content_of cell
    if highlighted_cell? cell
      content_highlighted
    else
      if distances && distances[cell]
        distances[cell].to_s(36).upcase # 0..9a..z
      else
        ' '
      end
    end
  end
end