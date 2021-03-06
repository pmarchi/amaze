
class Amaze::Grid::Ortho < Amaze::Grid

  def prepare_grid
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        Amaze::Cell::Square.new row, column
      end
    end
  end
  
  def configure_cell
    each_cell do |cell|
      row, column = cell.row, cell.column
      
      cell.north = self[row-1, column] 
      cell.east  = self[row, column+1]
      cell.south = self[row+1, column]
      cell.west  = self[row, column-1]
    end
  end
end

__END__

+---+---+
|   |   |
+---+---+
|   |   |
+---+---+

+------+------+
|      |      |
|      |      |
+------+------+
|      |      |
|      |      |
+------+------+
