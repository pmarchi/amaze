
class Amaze::Formatter::ASCII::Ortho < Amaze::Formatter::ASCII
  include Amaze::Formatter::ASCII::Symbols
  include Amaze::Formatter::ASCII::SquareHelper
  
  def coord cell
    [cell.column * dx, cell.row * dy]
  end
  
  def center_coord cell
    x0, y0 = coord cell
    [x0 + dx / 2, y0 + dy / 2]
  end
  
  def distance_coord cell
    x, _ = coord cell
    _, y = center_coord cell
    [x+1, y, dx-1]
  end
  
  def walls _
    {
      # dir   chars        ox  oy  fx fy
      north: [squ_h_wall, [0, 0],  [1, 0]],
      south: [squ_h_wall, [0, dy], [1, 0]],
      east:  [squ_v_wall, [dx, 0], [0, 1]],
      west:  [squ_v_wall, [0, 0],  [0, 1]],
    }
  end
  
  def paths cell
    c = center_char cell
    {
      # dir   chars                  fx  fy
      north: [[c, *squ_v_path[1..-2]], [ 0, -1]],
      south: [[c, *squ_v_path[1..-2]], [ 0,  1]],
      east:  [[c, *squ_h_path[1..-2]], [ 1,  0]],
      west:  [[c, *squ_h_path[1..-2]], [-1,  0]],
    }
  end
  
  def center_char cell
    return squ_cor if [:north, :east, :south, :west].count{|d| path?(d, cell) } >= 3
    return squ_v if path?(:north, cell) && path?(:south, cell)
    return squ_h if path?(:east, cell) && path?(:west, cell)
    squ_cen
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
end