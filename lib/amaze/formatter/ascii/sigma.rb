
class Amaze::Formatter::ASCII::Sigma < Amaze::Formatter::ASCII
  include Amaze::Formatter::ASCII::Symbols

  def coord cell
    [cell.column * dx, cell.row * dy + (cell.column.odd? ? oy : 0)]
  end
  
  def distance_coord cell
    x, y = coord cell
    [x + ox, y + oy, dx - ox]
  end

  def center_coord cell
    x, y = coord cell
    [x + (dx + oy - 1) / 2, y + oy]
  end
  
  def walls _
    {
      # dir       chars      ox  oy     fx fy
      north:     [hex_h_wall,  [ox, 0],   [1,  0]],
      south:     [hex_h_wall,  [ox, dy],  [1,  0]],
      northeast: [hex_db_wall, [dx, 1],   [1,  1]],
      southwest: [hex_db_wall, [0, oy+1], [1,  1]],
      northwest: [hex_df_wall, [0, oy],   [1, -1]],
      southeast: [hex_df_wall, [dx, dy],  [1, -1]],
    }
  end
  
  def paths _
    {
      # dir       chars      fx fy
      south:     [v6_path,  [ 0, 1]],
      southeast: [hex_db_path, [ 2, d6_path_i]],
      southwest: [hex_df_path, [-2, d6_path_i]],
    }
  end
  
  def dx
    cell_size * 4
  end
  
  def dy
    cell_size * 2
  end
  
  def ox
    cell_size
  end
  
  alias_method :oy, :ox
    
  def char_array_width
    grid.columns * dx + cell_size
  end
  
  def char_array_height
    grid.rows * dy + cell_size + 1
  end

  def hex_h_wall
    (hex_h * cell_size * 3).chars
  end
  
  def hex_df_wall
    (hex_df * cell_size).chars
  end
  
  def hex_db_wall
    (hex_db * cell_size).chars
  end
  
  def v6_path
    (hex_p * (cell_size * 2 + 1)).chars
  end
  
  def hex_df_path
    [hex_p] + (1..cell_size).map{ [hex_p_df, hex_p] }.flatten
  end
  
  def hex_db_path
    [hex_p] + (1..cell_size).map{ [hex_p_db, hex_p] }.flatten
  end
  
  def d6_path_i
    [0] + (1..cell_size).map{|i| [i, i] }.flatten
  end
end
