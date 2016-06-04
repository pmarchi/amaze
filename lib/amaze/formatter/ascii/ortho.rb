
class Amaze::Formatter::ASCII::Ortho < Amaze::Formatter::ASCII
  
  def draw_cell cell
    x0, y0 = coord cell

    # north & south
    h_wall.each_with_index do |c,i|
      char[y0][x0+i] = c.color(grid_color) unless cell.linked_to?(:north)
      char[y0+dy][x0+i] = c.color(grid_color) unless cell.linked_to?(:south)
    end
    
    # east & west
    v_wall.each_with_index do |c,i|
      char[y0+i][x0] = c.color(grid_color) unless cell.linked_to?(:west)
      char[y0+i][x0+dx] = c.color(grid_color) unless cell.linked_to?(:east)
    end
  end
  
  def draw_distances cell
    x0, _ = coord cell
    _, my = center_coord cell

    distance(cell).center(dx-1).chars.each_with_index do |c,i|
      char[my][x0+1+i] = c.color(*distance_color(cell))
    end
  end
  
  def draw_path cell
    mx, my = center_coord cell

    # north-south
    v_path.each_with_index do |c,i|
      char[my+i+1][mx] = c.color(path_color)
    end if path?(:south, cell)
    
    # east-west
    h_path.each_with_index do |c,i|
      char[my][mx+i+1] = c.color(path_color)
    end if path?(:east, cell)

    center_char = center
    center_char = v if path?(:north, cell) && path?(:south, cell)
    center_char = h if path?(:east, cell) && path?(:west, cell)
    center_char = corner if [:north, :east, :south, :west].count{|d| path?(d, cell) } >= 3
    char[my][mx] = center_char.color(path_color)
  end
  
  # x0, y0
  def coord cell
    [cell.column * dx, cell.row * dy]
  end
  
  # mx, my
  def center_coord cell
    x0, y0 = coord cell
    [x0 + dx / 2, y0 + dy / 2]
  end
  
  def dx
    cell_size * 3 + 1
  end
  
  def dy
    cell_size + 1
  end
  
  def char_array_width
    grid.columns * dx + 1
  end
  
  def char_array_height
    grid.rows * dy + 1
  end
  
  def h_wall
    (corner + h * (dx-1) + corner).chars
  end
  
  def v_wall
    (corner + v * (dy-1) + corner).chars
  end
  
  def h_path
    (h * (dx-1)).chars
  end
  
  def v_path
    (v * (dy-1)).chars
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