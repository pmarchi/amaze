
class Maze::HexGrid < Maze::Grid
  
  def prepare_grid
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        Maze::HexCell.new row, column
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
  
  def to_s
    # output = "\e[H\e[2J" # clear screen
    output = ""
    
    # top row
    repeat = ((columns + 0.5) / 2).round - 1
    output << " __" << "    __" * repeat << "\n"
    
    each_row do |row|
      top = "/"
      bottom = "\\"
      
      row.each do |cell|
        
        first_row = (cell.row == 0)
        last_row = (cell.row == rows-1)
        last_column = (cell.column == columns-1)
        
        if cell.column.even?
          top << "  \\"
          bottom << "__/"
        else
          top_east_boundary = (first_row && last_column) ? "__" : "__/"
          bottom_east_boundary = (last_row && last_column) ? "" : "  \\"
          top << top_east_boundary
          bottom << bottom_east_boundary
        end
      end

      output << top << "\n"
      output << bottom << "\n"
    end
    
    output
  end
end