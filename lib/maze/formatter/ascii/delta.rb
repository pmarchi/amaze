
class Maze::Formatter::ASCII::Delta < Maze::Formatter::ASCII

  def render
    side_a = "/"
    side_b = "\\"
    space = "  "
    highlighted = content_highlighted.center(height).blue
    base = "__" * (height - 1)
    
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
            body = (i == cell_size-1 && highlighted_cell?(cell)) ? highlighted : space * (height-1-i)
            # body = space * (height-1-i)
            wall = (cell.linked?(cell.east) ? " " : side_a)
          else
            if i < height-1 || cell.linked?(cell.south)
              body = (i == cell_size && highlighted_cell?(cell)) ? highlighted : space * i
              # body = space * i
            else
              body = base
            end
            wall = (cell.linked?(cell.east) ? " " : side_b)
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
end