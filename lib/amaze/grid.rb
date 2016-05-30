
class Amaze::Grid
  extend Amaze::Module::AutoRegisterSubclass
  
  # The number of rows
  attr_reader :rows

  # The number of columns
  attr_reader :columns
  
  # The grid
  attr_reader :grid
  
  # Initializes the grid and configures adjacent cells.
  #
  # Call from one of the subclasses.
  # (see {Amaze::Grid::Ortho}, {Amaze::Grid::Delta}, {Amaze::Grid::Sigma}, {Amaze::Grid::Upsilon}, {Amaze::Grid::Polar})
  #
  # @example Amaze::Grid::Ortho.new(10, 16)
  # @note Amaze::Grid does not implement a concrete tessellation of the grid.
  # @param rows [Integer] the number of rows
  # @param columns [Integer] the number of columns  
  def initialize rows, columns
    @rows = rows
    @columns = columns
    
    prepare_grid
    configure_cell
  end
  
  def prepare_grid
    raise NotImplementedError
  end
  
  def configure_cell
    raise NotImplementedError
  end
  
  def [](row, column)
    return nil unless row.between?(0, rows-1)
    return nil unless column.between?(0, columns-1)
    grid[row][column]
  end
  
  def each_row
    grid.each do |row|
      yield row
    end
  end
  
  def each_cell
    each_row do |row|
      row.each do |cell|
        yield cell if cell
      end
    end
  end

  def random_cell
    self[rand(rows), rand(columns)]
  end
  
  def deadends
    list = []
    each_cell do |cell|
      list << cell if cell.links.size == 1
    end
    list
  end

  def size
    rows * columns
  end
end

require 'amaze/grid/ortho'
require 'amaze/grid/delta'
require 'amaze/grid/sigma'
require 'amaze/grid/upsilon'
require 'amaze/grid/polar'
