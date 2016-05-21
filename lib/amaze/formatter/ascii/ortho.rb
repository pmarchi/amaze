
class Amaze::Formatter::ASCII::Ortho < Amaze::Formatter::ASCII
  
  def draw_cell cell
    left, right, top, bottom = coord cell
    
    # corners
    char[top][left] = corner.color(grid_color)
    char[top][right] = corner.color(grid_color)
    char[bottom][left] = corner.color(grid_color)
    char[bottom][right] = corner.color(grid_color)
    # top & bottom
    (left+1).upto(right-1) do |i|
      # top
      char[top][i] = h.color(grid_color) unless cell.linked_to?(:north)
      # bottom
      char[bottom][i] = h.color(grid_color) unless cell.linked_to?(:south)
    end
    # left & right
    (top+1).upto(bottom-1) do |i|
      # left
      char[i][left] = v.color(grid_color) unless cell.linked_to?(:west)
      # right
      char[i][right] = v.color(grid_color) unless cell.linked_to?(:east)
    end
  end

  def draw_content cell
    left, right, top, bottom = coord cell

    my = top + cell_size / 2 + 1
    distance(cell).center(cell_size * 3).chars.each_with_index do |c,i|
      char[my][left+1+i] = c.color(*distance_color(cell))
    end
  end

  def draw_path cell
    left, right, top, bottom = coord cell

    mx = left + (cell_size * 3 + 1) / 2
    my = top + cell_size / 2 + 1
    
    # TODO: simplify paths, draw only north-south and east-west
    
    # to north
    top.upto(my-1) do |i|
      char[i][mx] = v.color(path_color) if path?(:north, cell)
    end if top <= my-1
    # to east
    (mx+1).upto(right) do |i|
      char[my][i] = h.color(path_color) if path?(:east, cell)
    end if mx+1 <= right
    # to south
    (my+1).upto(bottom) do |i|
      char[i][mx] = v.color(path_color) if path?(:south, cell)
    end if my+1 <= bottom
    # to west
    left.upto(mx-1) do |i|
      char[my][i] = h.color(path_color) if path?(:west, cell)
    end if left <= mx-1
    # center, select the char depeding on how many paths cross the cell
    center_char = center
    center_char = v if path?(:north, cell) && path?(:south, cell)
    center_char = h if path?(:east, cell) && path?(:west, cell)
    center_char = corner if [:north, :east, :south, :west].select{|d| path?(d, cell) }.size >= 3
    char[my][mx] = center_char.color(path_color)
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
  
  def char_array_width
    x(grid.columns) + 1
  end
  
  def char_array_height
    y(grid.rows) + 1
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