
class Maze::Formatter::Ascii::Ortho < Maze::Formatter::Ascii

  def render grid, highlighted_cells=[]
    output = "\e[H\e[2J" # clear screen
    output += "+" + ("-" * cell_size * 3 + "+") * grid.columns + "\n"
    
    # h_line = "-" * cell_size * 3
    
    grid.each_row do |row|
      top = "|"
      marked = "|"
      bottom = "+"
      
      row.each do |cell|
        body = " " * cell_size * 3
        east_boundary = cell.linked?(cell.east) ? ' ' : '|'
        top << body << east_boundary
        
        if Array(highlighted_cells).include? cell
          body = "*".center(cell_size * 3)
        end
        marked << body << east_boundary
        
        south_boundary = (cell.linked?(cell.south) ? ' ' : '-') * cell_size * 3
        corner = "+"
        bottom << south_boundary << corner
      end
      
      cell_size.times do |i|
        if cell_size/2 == i
          output << marked << "\n"
        else
          output << top << "\n"
        end
      end
      output << bottom << "\n"
      
    end
    
    output
  end

end