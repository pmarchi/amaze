
class Maze::Formatter::ASCII::Ortho < Maze::Formatter::ASCII
  
  def render
    grid.each_cell do |cell|
      draw_cell cell
      draw_content cell
      draw_path cell
    end
    
    ansi_clear + char.map{|l| l.join }.join("\n")
  end
  
  def draw_cell cell
    left, right, top, bottom = coord cell
    
    # corners
    char[top][left] = corner
    char[top][right] = corner
    char[bottom][left] = corner
    char[bottom][right] = corner
    # top & bottom
    (left+1).upto(right-1) do |i|
      # top
      char[top][i] = h unless cell.linked? cell.north
      # bottom
      char[bottom][i] = h unless cell.linked? cell.south
    end
    # left & right
    (top+1).upto(bottom-1) do |i|
      # left
      char[i][left] = v unless cell.linked? cell.west
      # right
      char[i][right] = v unless cell.linked? cell.east
    end
  end

  def draw_content cell
    left, right, top, bottom = coord cell

    my = top + cell_size / 2 + 1
    content_of(cell).center(cell_size * 3).chars.each_with_index do |c,i|
      char[my][left+1+i] = c.color(content_color_of(cell))
    end
  end

  def draw_path cell
    return unless highlighted_cell? cell
    left, right, top, bottom = coord cell

    mx = left + (cell_size * 3 + 1) / 2
    my = top + cell_size / 2 + 1
    
    # to north
    top.upto(my-1) do |i|
      char[i][mx] = v.color(content_color_of cell) if path?(:north, cell)
    end if top <= my-1
    # to east
    (mx+1).upto(right) do |i|
      char[my][i] = h.color(content_color_of cell) if path?(:east, cell)
    end if mx+1 <= right
    # to south
    (my+1).upto(bottom) do |i|
      char[i][mx] = v.color(content_color_of cell) if path?(:south, cell)
    end if my+1 <= bottom
    # to west
    left.upto(mx-1) do |i|
      char[my][i] = h.color(content_color_of cell) if path?(:west, cell)
    end if left <= mx-1
    # center, select the char depeding on how many paths cross the cell
    center_char = center
    center_char = v if path?(:north, cell) && path?(:south, cell)
    center_char = h if path?(:east, cell) && path?(:west, cell)
    center_char = corner if [:north, :east, :south, :west].select{|d| path?(d, cell) }.size >= 3
    char[my][mx] = center_char.color(content_color_of(cell))
  end
  
  def path? direction, cell
    cell.linked?(cell.send(direction)) && highlighted_cell?(cell.send(direction))
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
  
  def center
    '∙'
  end
    
  def corner
    '+'
  end
end