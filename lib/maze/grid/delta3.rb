
class Maze::Grid::Delta3 < Maze::Grid

  def prepare_grid
    @columns = rows * 2 - 1
    
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        if column < rows-row-1 || column > columns-(rows-row)
          Maze::Cell::Square.new -1, -1
        else
          Maze::Cell::Square.new row,column
        end
      end
    end
  end
  
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

__END__
               /\
              /  \
             /    \
            /______\
           /\      /\
          /  \    /  \
         /    \  /    \
        /______\/______\
       /\      /\      /\
      /  \    /  \    /  \
     /    \  /    \  /    \
    /______\/______\/______\
   /\      /\      /\      /\
  /  \    /  \    /  \    /  \
 /    \  /    \  /    \  /    \
/______\/______\/______\/______\
