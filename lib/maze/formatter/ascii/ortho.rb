
class Maze::Formatter::ASCII::Ortho < Maze::Formatter::ASCII

  def render
    output = ansi_clear
    output << corner << (h_line + corner) * grid.columns << "\n"
    
    grid.each_row do |row|
      top = v_line.dup      # all without bottom and middle line
      middle = v_line.dup   # exact middle
      bottom = corner.dup
      
      row.each do |cell|
        east_boundary = cell.linked?(cell.east) ? v_space : v_line
        top << h_space << east_boundary
        
        body = (highlighted_cell?(cell) ? content_highlighted : contents_of(cell)).center(cell_size * 3).blue
        middle << body << east_boundary
        
        south_boundary = cell.linked?(cell.south) ? h_space : h_line
        bottom << south_boundary << corner
      end
      
      cell_size.times do |i|
        output << (cell_size/2 == i ? middle : top) << "\n"
      end
      output << bottom << "\n"
    end
    
    output
  end

  def v_line
    '|'
  end
  
  def v_space
    ' '
  end
  
  def h_line
    '-' * cell_size * 3
  end
  
  def h_space
    ' ' * cell_size * 3
  end
  
  def corner
    '+'
  end
end