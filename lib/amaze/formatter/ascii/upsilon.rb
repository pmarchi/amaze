
class Amaze::Formatter::ASCII::Upsilon < Amaze::Formatter::ASCII
  include Amaze::Formatter::ASCII::Symbols
  include Amaze::Formatter::ASCII::SquareHelper
  
  def coord cell
    [cell.column * dx, cell.row * dy]
  end
  
  def distance_coord cell
    x, _ = coord cell
    _, y = center_coord cell
    [x+ox+1, y, cell_size * 3]
  end

  def center_coord cell
    x0, y0 = coord cell
    [x0 + (dx + ox) / 2, y0 + (dy + oy) / 2]
  end
  
  def walls cell
    if (cell.row + cell.column).even?
      {
        # dir       chars          ox  oy         fx fy
        north:     [squ_h_wall,   [ox, 0],       [1,  0]],
        south:     [squ_h_wall,   [ox, dy + oy], [1,  0]],
        east:      [squ_v_wall,   [dx + ox, oy], [0,  1]],
        west:      [squ_v_wall,   [0,       oy], [0,  1]],
        northeast: [octo_db_wall, [dx, 0],       [1,  1]],
        southeast: [octo_df_wall, [dx, dy + oy], [1, -1]],
        southwest: [octo_db_wall, [0,  dy],      [1,  1]],
        northwest: [octo_df_wall, [0,  oy],      [1, -1]],
      }
    else
      {
        # dir       chars         ox  oy         fx fy
        north:     [squ_h_wall,  [ox, oy],      [1,  0]],
        south:     [squ_h_wall,  [ox, dy],      [1,  0]],
        east:      [squ_v_wall,  [dx, oy],      [0,  1]],
        west:      [squ_v_wall,  [ox, oy],      [0,  1]],
      }
    end
  end
  
  def paths cell
    paths = {
      # dir   chars        fx fy
      south: [squ_v_path, [0, 1]],
      east:  [squ_h_path, [1, 0]],
    }
    paths.merge!({
      # dir       chars     fx  fy
      southeast: [octo_db_path, [ 1, octo_d_path_i]],
      southwest: [octo_df_path, [-1, octo_d_path_i]],
    }) if (cell.row + cell.column).even?
    paths
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

  def octo_df_wall
    (octo_cor + octo_df * cell_size + octo_cor).chars
  end
  
  def octo_db_wall
    (octo_cor + octo_db * cell_size + octo_cor).chars
  end
  
  def octo_df_path
    (octo_cen + octo_df2 * cell_size + octo_cen + octo_df2 * cell_size + octo_cen).chars
  end
  
  def octo_db_path
    (octo_cen + octo_db2 * cell_size + octo_cen + octo_db2 * cell_size + octo_cen).chars
  end
  
  def octo_d_path_i
    o = cell_size + 1
    [0, (1..cell_size).map{|i| [i,i,i+o,i+o] }, o, o+o].flatten.sort
  end
end