
class Amaze::Formatter::ASCII::Delta < Amaze::Formatter::ASCII

  def draw_cell cell
    x, y = coord cell
    
    walls(cell).each do |direction, (chars, (ox, oy), (fx, fy))|
      chars.each_with_index do |c,i|
        char[y+oy+fy*i][x+ox+fx*i] = c.color(grid_color) unless cell.linked_to? direction
      end
    end
  end
  
  def draw_distance_coord cell
    oy = dy / 2
    w = 2 * (dx - oy) - 1

    x0, y0 = coord cell
    x = x0 + oy + 1
    y = y0 + ((cell.column + cell.row).even? ? oy : dy - oy)
    
    return [x, y, w]
  end
  
  def draw_path cell
    x, y = center_coord cell
    
    paths(cell).each do |direction, (chars, (fx, fy))|
      chars.each_with_index do |c,i|
        char[y+fy*i][x+fx*i] = c.color(path_color) if path?(direction, cell)
      end
    end
  end
  
  def coord cell
    [cell.column * dx, cell.row * dy]
  end
  
  def center_coord cell
    x, y = coord cell
    [x + dx, y + dy / 2]
  end
  
  def walls cell
    if (cell.column + cell.row).even?
      {
        # dir   chars      ox  oy    fx fy
        north: [h3_wall,  [0,   0], [1,  0]],
        west:  [db3_wall, [0,   0], [1,  1]],
        east:  [df3_wall, [dx, dy], [1, -1]],
      }
    else
      {
        # dir   chars      ox oy    fx fy
        south: [h3_wall,  [0, dy], [1,  0]],
        west:  [df3_wall, [0, dy], [1, -1]],
        east:  [db3_wall, [dx, 0], [1,  1]],
      }
    end
  end
  
  def paths _
    {
      # dir   chars     fx fy
      south: [v3_path, [0, 1]],
      east:  [h3_path, [1, 0]],
    }
  end
  
  def h3_wall
    (corner + h3 * (cell_size * 2 + 1) + corner).chars
  end
  
  def df3_wall
    (corner + df3 * cell_size + corner).chars
  end
  
  def db3_wall
    (corner + db3 * cell_size + corner).chars
  end
  
  def h3_path
    (center + h3 * cell_size + center).chars
  end
  
  def v3_path
    (center + v3 * cell_size + center).chars
  end
  
  def dx
    cell_size + 1
  end
  
  alias_method :dy, :dx
  
  def char_array_width
    (grid.columns + 1) * dx + 1
  end
  
  def char_array_height
    grid.rows * dy + 1
  end
  
  def h3
    '-'
  end
  
  def v3
    '|'
  end
  
  def df3
    '/'
  end
  
  def db3
    '\\'
  end
  
  def corner
    '∙'
  end
  
  alias_method :center, :corner
end
