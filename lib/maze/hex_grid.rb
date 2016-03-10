
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
  
  def to_s marked_cells=[]
    line = "___" * cell_size
    space = "   " * cell_size
    marked = "*".center(cell_size*3)
    upper_east = "\\"
    lower_east = "/"
    upper_west = "/"
    lower_west = "\\"
    empty_side = " "
    
    output = "\e[H\e[2J" # clear screen

    # top row
    repeat = ((columns + 0.5) / 2).round - 1
    output << " " * cell_size << line
    output << (" " * cell_size * 2 + space + line) * repeat << "\n"
    
    each_row do |row|
      upper = Array.new(cell_size) { "" }
      lower = Array.new(cell_size) { "" }
      
      cell_size.times do |i|
        upper[i] << " " * (cell_size-1-i) << upper_west
        lower[i] << " " * i << lower_west
      end

      row.each do |cell|
        if cell.column.even?
          cell_size.times do |i|
            # upper half of cell
            north = " " * i + ((Array(marked_cells).include?(cell) && i == (cell_size-1)) ? marked : space) + " " * i
            north_east = (cell.linked? cell.northeast) ? empty_side : upper_east
            upper[i] << north << north_east

            # lower half of cell
            south = (i < (cell_size-1) || cell.linked?(cell.south)) ? space + " " * (cell_size-1-i) * 2 : line
            south_east = (cell.linked? cell.southeast) ? empty_side : lower_east
            lower[i] << south << south_east
          end
        else
          cell_size.times do |i|
            # lower half of cell from row above
            south = (i < (cell_size-1) || cell.linked?(cell.north)) ? space + " " * (cell_size-1-i) * 2 : line
            south_east = (cell.north || cell.northeast) ? 
              (cell.north && cell.northeast && cell.north.linked?(cell.northeast)) ? 
                empty_side : 
                lower_east :
              ""
            upper[i] << south << south_east

            # upper half of cell from current row
            north = " " * i + ((Array(marked_cells).include?(cell) && i == (cell_size-1)) ? marked : space) + " " * i
            north_east = (cell.linked? cell.northeast) ? empty_side : upper_east
            lower[i] << north << north_east
          end
        end
      end
      
      cell_size.times {|i| output << upper[i] << "\n" }
      cell_size.times {|i| output << lower[i] << "\n" }
    end
    
    # last lower half of cells
    repeat = columns / 2
    cell_size.times do |i|
      south = (i < (cell_size-1)) ? space : line
      output << " " * (cell_size-i)
      output << (" " * i * 2 + space + lower_west + " " * (cell_size-1-i) * 2 + south + lower_east) * repeat
      output << "\n"
    end

    output
  end
end