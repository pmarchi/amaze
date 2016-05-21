
class Amaze::Grid::Sigma < Amaze::Grid
  
  def prepare_grid
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        Amaze::Cell::Hex.new row, column
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

__END__

 __    __    __
/  \__/  \__/  \__
\__/  \__/  \__/  \
/  \__/  \__/  \__/
\__/  \__/  \__/  \
/  \__/  \__/  \__/
\__/  \__/  \__/  \
/  \__/  \__/  \__/
\__/  \__/  \__/  \
   \__/  \__/  \__/

  ______          ______          ______
 /      \        /      \        /      \
/        \______/        \______/        \______
\        /      \        /      \        /      \
 \______/        \______/        \______/        \
 /      \        /      \        /      \        /
/        \______/        \______/        \______/
\        /      \        /      \        /      \
 \______/        \______/        \______/        \
 /      \        /      \        /      \        /
/        \______/        \______/        \______/
\        /      \        /      \        /      \
 \______/        \______/        \______/        \
        \        /      \        /      \        /
         \______/        \______/        \______/
