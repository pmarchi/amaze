
class Maze::DeltaGrid < Maze::Grid
  
  include Maze::Formatter::Ascii::Delta
  
  def configure_cell
    each_cell do |cell|
      row, column = cell.row, cell.column
      
      cell.east = self[row, column+1]
      cell.west = self[row, column-1]
      
      if (row+column).even?
        cell.north = self[row-1, column]
      else
        cell.south = self[row+1, column]
      end
    end
  end
end