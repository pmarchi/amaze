
require 'rainbow/ext/string'

class Amaze::Formatter::ASCII
  extend Amaze::Module::AutoRegisterSubclass

  # The grid
  attr_reader :grid
  
  # Options for the ASCII renderer
  attr_reader :options
  
  def initialize grid, options={}
    @grid = grid
    @options = options
  end
  
  def char
    @char ||= Array.new(char_array_height) do
      Array.new(char_array_width) do
        blank
      end
    end
  end  

  def render
    render_cells
    render_distances if distances
    render_path

    ansi_clear + char.map{|l| l.join }.join("\n")
  end
  
  def render_cells
    grid.each_cell do |cell|
      draw_cell cell
    end
  end
  
  def render_distances
    grid.each_cell do |cell|
      draw_distance cell
    end
  end
  
  def render_path
    grid.each_cell do |cell|
      draw_path cell if path_cell? cell
    end
  end
  
  def draw_cell cell
    x, y = coord cell
    
    walls(cell).each do |direction, (chars, (ox, oy), (fx, fy))|
      next if cell.linked_to? direction
      chars.each_with_index do |c,i|
        char[y+oy+fy*i][x+ox+fx*i] = c.color(grid_color)
      end
    end
  end
  
  def draw_distance cell
    x, y, w = distance_coord cell

    distance(cell).center(w).chars.each_with_index do |c,i|
      char[y][x+i] = c.color(*distance_color(cell))
    end
  end
  
  def draw_path cell
    x, y = center_coord cell
    
    paths(cell).each do |direction, (chars, (fx, fy))|
      next unless path?(direction, cell)
      ox = fx.is_a?(Fixnum) ? ->(i) { fx * i } : ->(i) { fx[i] }
      oy = fy.is_a?(Fixnum) ? ->(i) { fy * i } : ->(i) { fy[i] }
      chars.each_with_index do |c,i|
        char[y+oy.call(i)][x+ox.call(i)] = c.color(path_color)
      end
    end
  end

  def path? direction, cell
    cell.linked?(cell.send(direction)) && path_cell?(cell.send(direction))
  end
  
  def ansi_clear
    "\e[H\e[2J"
  end
  
  def blank
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
  
  def distance_color cell
    return @options[:distances_color] if @options[:distances_color]
    _, max = distances.max
    high = (255-47).to_f / max * distances[cell] + 47
    low = high / 4
    p [:low, low] unless (0..255).include? low
    p [:high, high] unless (0..255).include? high
    [0,low,high]
  end

  def self.colors
    Rainbow::X11ColorNames::NAMES.keys
  end
end

require 'amaze/formatter/ascii/symbols'
require 'amaze/formatter/ascii/square_helper'
require 'amaze/formatter/ascii/delta'
require 'amaze/formatter/ascii/ortho'
require 'amaze/formatter/ascii/sigma'
require 'amaze/formatter/ascii/upsilon'
require 'amaze/formatter/ascii/polar'
