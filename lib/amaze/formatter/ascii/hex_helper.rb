
module Amaze::Formatter::ASCII::HexHelper
  def h6_wall
    (h6 * cell_size * 3).chars
  end
  
  def df6_wall
    (df6 * cell_size).chars
  end
  
  def db6_wall
    (db6 * cell_size).chars
  end
  
  def v6_path
    (p6 * (cell_size * 2 + 1)).chars
  end
  
  def df6_path
    [p6] + v6_path[1..-1].map{|c| [pdf6, c] }.flatten
  end
  
  def db6_path
    [p6] + v6_path[1..-1].map{|c| [pdb6, c] }.flatten
  end
  
  def d6_path_i
    [0] + (1..cell_size).map{|i| [i, i] }.flatten
  end
  
  def h6
    '_'
  end
  
  def df6
    '/'
  end
  
  def db6
    '\\'
  end
  
  def p6
    '.'
  end
  
  def pdf6
    '´'
  end
  
  def pdb6
    '`'
  end
end
