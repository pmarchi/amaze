
# all rainbow colors: Rainbow::X11ColorNames::NAMES.keys
require 'rainbow/ext/string'

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
  
  def char
    @char ||= Array.new(char_array_height) do |x|
      Array.new(char_array_width) do |y|
        clear
      end
    end
  end  

  def render
    grid.each_cell do |cell|
      draw_cell cell
      draw_content cell if distances
      draw_path cell if path_cell? cell
    end
    
    ansi_clear + char.map{|l| l.join }.join("\n")
  end
  
  def path? direction, cell
    cell.linked?(cell.send(direction)) && path_cell?(cell.send(direction))
  end
  
  def ansi_clear
    "\e[H\e[2J"
  end
  
  def clear
    ' '
  end
  
  # The size of the cell
  def cell_size
    options[:cell_size] || 1
  end
  
  # The color of the grid
  def grid_color
    options[:grid_color] || :white
  end
  
  # The color used to draw the solution or the longest path
  def path_color
    options[:path_color] || :blue
  end
  
  def path_cell? cell
    Array(options[:path_cells]).include? cell
  end
  
  # Distances
  def distances
    options[:distances]
  end
  
  def distance cell
    # .to_s(36) => 0..9a..z
    distances && distances[cell] ? distances[cell].to_s(36).upcase : ' '
  end

  def distances_color
    @options[:distances_color] || :blue
  end
end