
class Maze::Formatter::ASCII::Ortho < Maze::Formatter::ASCII

  def render grid, highlighted_cells=[]
    v_line = '|'
    v_space = ' '
    h_line = '-' * cell_size * 3
    h_space = ' ' * cell_size * 3
    corner = '+'
    highlighted = '*'.center(cell_size * 3)

    output = "\e[H\e[2J" # clear screen
    output << corner << (h_line + corner) * grid.columns << "\n"
    
    grid.each_row do |row|
      top = v_line.dup      # all without bottom and middle line
      middle = v_line.dup   # exact middle
      bottom = corner.dup
      
      row.each do |cell|
        east_boundary = cell.linked?(cell.east) ? v_space : v_line
        top << h_space << east_boundary
        
        body = Array(highlighted_cells).include?(cell) ? highlighted : h_space
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

end