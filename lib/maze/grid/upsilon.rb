class Maze::Grid::Upsilon < Maze::Grid
  
  def prepare_grid
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        if (row+column).even?
          Maze::Cell::Octo.new row, column
        else
          Maze::Cell::Square.new row, column
        end
      end
    end
  end
  
  def configure_cell
    each_cell do |cell|
      row, column = cell.row, cell.column

      cell.north = self[row-1, column]
      cell.east = self[row, column+1]
      cell.south = self[row+1, column]
      cell.west = self[row, column-1]

      # Octo
      if (cell.row+cell.column).even?
        cell.northeast = self[row-1, column+1]
        cell.southeast = self[row+1, column+1]
        cell.southwest = self[row+1, column-1]
        cell.northwest = self[row-1, column-1]
      end
    end
  end
end

__END__

  +---+       +---+       +---+      
 /     \     /     \     /     \     
+       +---+       +---+       +---+
|       |   |       |   |       |   |
+       +---+       +---+       +---+
 \     /     \     /     \     /     \
  +---+       +---+       +---+       +
  |   |       |   |       |   |       |
  +---+       +---+       +---+       +
 /     \     /     \     /     \     /
+       +---+       +---+       +---+
|       |   |       |   |       |   |
+       +---+       +---+       +---+
 \     /     \     /     \     /     \
  +---+       +---+       +---+       +
  |   |       |   |       |   |       |
  +---+       +---+       +---+       +
 /     \     /     \     /     \     /
+       +---+       +---+       +---+
|       |   |       |   |       |   |
+       +---+       +---+       +---+
 \     /     \     /     \     /     
  +---+       +---+       +---+      

     
     
     
     
     
     
     
     
     
     
     
     
     
     