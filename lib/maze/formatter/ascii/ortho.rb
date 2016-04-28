
class Maze::Formatter::ASCII::Ortho < Maze::Formatter::ASCII
  
  # TODO: render ascii output with char arrays

  def render2
    output = ansi_clear
    output << corner << (h_line + corner) * grid.columns << "\n"
    
    grid.each_row do |row|
      top = v_line.dup      # all without bottom and middle line
      middle = v_line.dup   # exact middle
      bottom = corner.dup
      
      row.each do |cell|
        cell ||= dummy_cell # assign dummy cell for masked cells
        
        east_boundary = cell.linked?(cell.east) ? v_space : v_line
        top << h_space << east_boundary
        
        body = content_of(cell).center(cell_size * 3).send(content_color_of(cell))
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
  
  def render
    grid.each_cell do |cell|
      draw cell
    end
    
    char.map{|l| l.join }.join("\n")
  end
  
  def draw cell
    left, right, top, bottom = coord cell
    
    # corners
    char[top][left] = corner
    char[top][right] = corner
    char[bottom][left] = corner
    char[bottom][right] = corner
    # top & bottom
    (left+1).upto(right-1) {|i| char[top][i] = h; char[bottom][i] = h }
    # left & right
    (top+1).upto(bottom-1) {|i| char[i][left] = v; char[i][right] = v }
  end
  
  def char
    @char ||= Array.new(y(grid.rows) + 1) do |x|
      Array.new(x(grid.columns) + 1) do |y|
        ' '
      end
    end
  end  

  # left, right, top, bottom
  def coord cell
    [x(cell.column), x(cell.column+1), y(cell.row), y(cell.row+1)]
  end
  
  def x column
    (cell_size * 3 + 1) * column
  end
  
  def y row
    (cell_size + 1) * row
  end
  
  def h
    '-'
  end
  
  def v
    '|'
  end
  
  # OLD
  
  def dummy_cell
    Maze::Cell::Square.new -1, -1
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