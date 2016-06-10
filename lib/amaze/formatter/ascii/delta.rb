
class Amaze::Formatter::ASCII::Delta < Amaze::Formatter::ASCII
  include Amaze::Formatter::ASCII::Symbols
  
  def coord cell
    [cell.column * dx, cell.row * dy]
  end
  
  def distance_coord cell
    oy = dy / 2
    w = 2 * (dx - oy) - 1

    x0, y0 = coord cell
    x = x0 + oy + 1
    y = y0 + ((cell.column + cell.row).even? ? oy : dy - oy)
    
    return [x, y, w]
  end
  
  def center_coord cell
    x, y = coord cell
    [x + dx, y + dy / 2]
  end
  
  def walls cell
    if (cell.column + cell.row).even?
      {
        # dir   chars         ox  oy    fx fy
        north: [tri_h_wall,  [0,   0], [1,  0]],
        west:  [tri_db_wall, [0,   0], [1,  1]],
        east:  [tri_df_wall, [dx, dy], [1, -1]],
      }
    else
      {
        # dir   chars         ox oy    fx fy
        south: [tri_h_wall,  [0, dy], [1,  0]],
        west:  [tri_df_wall, [0, dy], [1, -1]],
        east:  [tri_db_wall, [dx, 0], [1,  1]],
      }
    end
  end
  
  def paths _
    {
      # dir   chars        fx fy
      south: [tri_v_path, [0, 1]],
      east:  [tri_h_path, [1, 0]],
    }
  end
  
  def tri_h_wall
    (tri_cor + tri_h * (cell_size * 2 + 1) + tri_cor).chars
  end
  
  def tri_df_wall
    (tri_cor + tri_df * cell_size + tri_cor).chars
  end
  
  def tri_db_wall
    (tri_cor + tri_db * cell_size + tri_cor).chars
  end
  
  def tri_h_path
    (tri_cen + tri_h * cell_size + tri_cen).chars
  end
  
  def tri_v_path
    (tri_cen + tri_v * cell_size + tri_cen).chars
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
end
