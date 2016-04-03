
module Maze::MaskedGrid
  
  # The mask
  attr_reader :mask
  
  def initialize mask
    @mask = mask
    super mask.rows, mask.columns
  end
  
  def prepare_grid
    super

    each_cell do |cell|
      row, column = cell.row, cell.column
      grid[row][column] = nil unless mask[row, column]
    end
  end
  
  def random_cell
    row, column = mask.random_location
    self[row, column]
  end
  
  def size
    mask.count
  end
end