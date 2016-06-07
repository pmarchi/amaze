
module Amaze::Formatter::ASCII::OctoHelper
  def df_wall
    (corner + df * cell_size + corner).chars
  end
  
  def db_wall
    (corner + db * cell_size + corner).chars
  end
  
  def df_path
    (center + dfp * cell_size + center + dfp * cell_size + center).chars
  end
  
  def db_path
    (center + dbp * cell_size + center + dbp * cell_size + center).chars
  end
  
  def d_path_i
    o = cell_size + 1
    [0, (1..cell_size).map{|i| [i,i,i+o,i+o] }, o, o+o].flatten.sort
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
end
