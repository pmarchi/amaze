
class Maze::SigmaGrid < Maze::Grid
  
  include Maze::Formatter::Ascii::Sigma
  
  def prepare_grid
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        Maze::SigmaCell.new row, column
      end
    end
  end
  
  def configure_cell
    each_cell do |cell|
      row, column = cell.row, cell.column
      
      cell.north = self[row-1, column] 
      cell.south = self[row+1, column]

      if column.even?
        cell.northeast = self[row-1, column+1]
        cell.southeast = self[row,column+1]
        cell.northwest = self[row-1, column-1]
        cell.southwest = self[row, column-1]
      else
        cell.northeast = self[row, column+1]
        cell.southeast = self[row+1,column+1]
        cell.northwest = self[row, column-1]
        cell.southwest = self[row+1, column-1]
      end
    end
  end
end