
module Amaze::Formatter::ASCII::SquareHelper
  def squ_h_wall
    (squ_cor + squ_h * cell_size * 3 + squ_cor).chars
  end
  
  def squ_v_wall
    (squ_cor + squ_v * cell_size + squ_cor).chars
  end
  
  def squ_h_path
    (squ_cen + squ_h * (dx-1) + squ_cen).chars
  end
  
  def squ_v_path
    (squ_cen + squ_v * (dy-1) + squ_cen).chars
  end
end