
class Maze::Formatter::PNG::Polar < Maze::Formatter::PNG
  
  def render_background
  end
  
  def render
    grid.each_cell do |cell|
      next if cell.row == 0
      ax, ay, bx, by, cx, cy, dx, dy = coord cell
      
      image.line ax, ay, cx, cy, wall_color unless cell.linked_to?(:inward)
      image.line cx, cy, dx, dy, wall_color unless cell.linked_to?(:cw)
    end
    
    image.circle(image_center, image_center, grid.rows * cell_size, wall_color)
  end
  
  def coord cell
    theta = 2 * Math::PI / grid.columns(cell.row).size
    inner_radius = cell.row * cell_size
    outer_radius = (cell.row + 1) * cell_size
    theta_ccw = cell.column * theta
    theta_cw = (cell.column + 1) * theta
    
    ax = image_center + (inner_radius * Math.cos(theta_ccw)).to_i
    ay = image_center + (inner_radius * Math.sin(theta_ccw)).to_i
    bx = image_center + (outer_radius * Math.cos(theta_ccw)).to_i
    by = image_center + (outer_radius * Math.sin(theta_ccw)).to_i
    cx = image_center + (inner_radius * Math.cos(theta_cw)).to_i
    cy = image_center + (inner_radius * Math.sin(theta_cw)).to_i
    dx = image_center + (outer_radius * Math.cos(theta_cw)).to_i
    dy = image_center + (outer_radius * Math.sin(theta_cw)).to_i
    
    [ax, ay, bx, by, cx, cy, dx, dy]
  end
  
  def image
    @image ||= ChunkyPNG::Image.new image_size, image_size, background_color
  end
    
  def image_size
    cell_size * grid.rows * 2 + border * 2 + 1
  end
  
  def image_center
    image_size / 2
  end
end