
class Maze::DeltaGrid < Maze::Grid
  
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
  
  def to_s marked_cells=[]
    height = cell_size * 2
    side_a = "/"
    side_b = "\\"
    space = "  "
    base = "__" * (height - 1)
    
    # output = "\e[H\e[2J" # clear screen
    output = ""
    
    repeat = (columns-1) / 2
    output << " " << base << ("  " + base) * repeat << "\n"
    
    each_row do |row|
      line = Array.new(height) { "" }

      # left side of first cell of row
      height.times do |i|
        if row.first.row.even?
          line[i] << " " * i + side_b
        else
          line[i] << " " * (height-1-i) + side_a
        end
      end
      
      # remaining cells of row
      row.each do |cell|
        height.times do |i|
          if (cell.row+cell.column).even?
            line[i] << "  " * (height-1-i) + (cell.linked?(cell.east) ? " " : side_a)
          else
            body = (i < height-1 || cell.linked?(cell.south)) ? space * i : base
            line[i] << body + (cell.linked?(cell.east) ? " " : side_b)
          end
        end
      end

      # add all lines for a single row to output
      height.times do |i|
        output << line[i] << "\n"
      end
      
    end
    
    output
  end
end