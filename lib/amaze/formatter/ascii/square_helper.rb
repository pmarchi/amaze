
module Amaze::Formatter::ASCII::SquareHelper
  def h_wall
    (corner + h * cell_size * 3 + corner).chars
  end
  
  def v_wall
    (corner + v * cell_size + corner).chars
  end
  
  def h_path
    (center + h * (dx-1) + center).chars
  end
  
  def v_path
    (center + v * (dy-1) + center).chars
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