
class Maze::Formatter::ASCII::Delta < Maze::Formatter::ASCII

  def render
    highlighted = content_highlighted.center(height).blue
    
    output = ansi_clear
    
    repeat = (grid.columns-1) / 2
    output << " " << base << ("  " + base) * repeat << "\n"
    
    grid.each_row do |row|
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
            body = (i == cell_size-1 ? contents_of(cell) : '').center((height-1-i)*2).blue
            wall = cell.linked?(cell.east) ? " " : side_a
          else
            if i < height-1 || cell.linked?(cell.south)
              body = (i == cell_size ? contents_of(cell) : '').center(i*2).blue
              # body = space * i
            else
              # FIX: if cell_size == 1 the body of the cell and the bottom of the cell
              # will be drawn by the same characters. Use underline? Underline will 
              # cause problems with the color. Don't fix it for the moment.
              body = base
            end
            wall = cell.linked?(cell.east) ? " " : side_b
          end
          line[i] << body << wall
        end
      end

      # add all lines for a single row to output
      height.times do |i|
        output << line[i] << "\n"
      end
      
    end
    
    output
  end
  
  def height
    cell_size * 2
  end

  def side_a
    "/"
  end
  
  def side_b
    "\\"
  end
  
  def space
    "  "
  end
  
  def base
    "__" * (height - 1)
  end
end