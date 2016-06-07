
class Amaze::Formatter::ASCII::Upsilon < Amaze::Formatter::ASCII
  
  def draw_cell cell
    x0, y0 = coord cell
    
    if (cell.row + cell.column).even?
      # octo cell
      df_wall.each_with_index do |c,i|
        char[y0+oy-i][x0+i] = c.color(grid_color) unless cell.linked_to?(:northwest)
        char[y0+dy+oy-i][x0+dx+i] = c.color(grid_color) unless cell.linked_to?(:southeast)
      end

      db_wall.each_with_index do |c,i|
        char[y0+i][x0+dx+i] = c.color(grid_color) unless cell.linked_to?(:northeast)
        char[y0+dy+i][x0+i] = c.color(grid_color) unless cell.linked_to?(:southwest)
      end

      y1, y2 = y0, y0 + dy + oy
      x1, x2 = x0, x0 + dx + ox
    else
      # square cell
      y1, y2 = y0 + oy, y0 + dy
      x1, x2 = x0 + ox, x0 + dx
    end

    h_wall.each_with_index do |c,i|
      char[y1][x0+ox+i] = c.color(grid_color) unless cell.linked_to?(:north)
      char[y2][x0+ox+i] = c.color(grid_color) unless cell.linked_to?(:south)
    end

    v_wall.each_with_index do |c,i|
      char[y0+oy+i][x1] = c.color(grid_color) unless cell.linked_to?(:west)
      char[y0+oy+i][x2] = c.color(grid_color) unless cell.linked_to?(:east)
    end
  end
  
  def draw_distances cell
    x0, _ = coord cell
    _, my = center_coord cell
    distance(cell).center(cell_size * 3).chars.each_with_index do |c,i|
      char[my][x0+ox+i+1] = c.color(*distance_color(cell))
    end
  end

  def draw_path cell
    mx, my = center_coord cell

    # north-south
    v_path.each_with_index do |c,i|
      char[my+i][mx] = c.color(path_color)
    end if path?(:south, cell)

    # west-east
    h_path.each_with_index do |c,i|
      char[my][mx+i] = c.color(path_color)
    end if path?(:east, cell)
    
    return unless (cell.column+cell.row).even?

    # northwest-southeast
    db_path.each_with_index do |c,i|
      char[my+db_path_i[i]][mx+i] = c.color(path_color)
    end if path?(:southeast, cell)
    
    # northeast-southwest
    df_path.each_with_index do |c,i|
      char[my+df_path_i[i]][mx-i] = c.color(path_color)
    end if path?(:southwest, cell)
  end
  
  # x0, y0
  def coord cell
    [cell.column * dx, cell.row * dy]
  end
  
  def center_coord cell
    x0, y0 = coord cell
    [x0 + (dx + ox) / 2, y0 + (dy + oy) / 2]
  end
  
  def ox
    cell_size + 1
  end
  
  alias_method :oy, :ox
  
  def dx
    cell_size * 4 + 2
  end
  
  def dy
    cell_size * 2 + 2
  end
  
  def char_array_width
    grid.columns * dx + ox + 1
  end
  
  def char_array_height
    grid.rows * dy + oy + 1
  end
  
  def h_wall
    (corner + h * cell_size * 3 + corner).chars
  end
  
  def v_wall
    (corner + v * cell_size + corner).chars
  end
  
  def df_wall
    (corner + df * cell_size + corner).chars
  end
  
  def db_wall
    (corner + db * cell_size + corner).chars
  end
  
  def h_path
    (center + h * (dx-1) + center).chars
  end
  
  def v_path
    (center + v * (dy-1) + center).chars
  end
  
  def df_path
    (center + dfp * cell_size + center + dfp * cell_size + center).chars
  end
  
  def db_path
    (center + dbp * cell_size + center + dbp * cell_size + center).chars
  end
  
  def df_path_i
    o = cell_size + 1
    [0, (1..cell_size).map{|i| [i,i,i+o,i+o] }, o, o+o].flatten.sort
  end
  
  alias_method :db_path_i, :df_path_i
  
  def h
    '-'
  end
  
  def v
    '|'
  end
  
  def df
    '/'
  end
  
  def db
    '\\'
  end
  
  def dfp
    '´.'
  end
  
  def dbp
    '`.'
  end
  
  def center
    '∙'
  end
    
  def corner
    '+'
  end
end