
class Amaze::Grid
  extend Amaze::Module::AutoRegisterSubclass
  
  # The dimension of the amaze
  attr_reader :rows, :columns
  
  # The grid
  attr_reader :grid
    
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
