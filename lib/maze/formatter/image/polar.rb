
class Maze::Formatter::Image::Polar < Maze::Formatter::Image
  
  def render_background
  end
  
  def render_grid
    canvas.stroke_antialias true
    canvas.stroke_linecap 'square'
    canvas.stroke 'gray90'
    canvas.stroke_width 1
    canvas.fill 'none'

    grid.each_cell do |cell|
      next if cell.row == 0
      ax, ay, bx, by, cx, cy, dx, dy, radius, ccw, cw = coord cell
  
      canvas.ellipse image_center, image_center, radius, radius, ccw, cw
      canvas.line cx, cy, dx, dy
    end
    canvas.ellipse(image_center, image_center, grid.rows * cell_width, grid.rows * cell_width, 0, 360)
  end
  
  def render_wall
    canvas.stroke_antialias true
    canvas.stroke_linecap 'square'
    canvas.stroke wall_color
    canvas.stroke_width wall_width
    canvas.fill 'none'

    grid.each_cell do |cell|
      next if cell.row == 0
      ax, ay, bx, by, cx, cy, dx, dy, radius, ccw, cw = coord cell
      
      canvas.ellipse image_center, image_center, radius, radius, ccw, cw unless cell.linked_to?(:inward)
      canvas.line cx, cy, dx, dy unless cell.linked_to?(:cw)
    end
    
    canvas.ellipse(image_center, image_center, grid.rows * cell_width, grid.rows * cell_width, 0, 360)
  end
  
  def render_path
    canvas.stroke_antialias true
    canvas.stroke_linecap 'square'
    canvas.fill 'none'
    canvas.stroke path_color
    canvas.stroke_width path_width

    grid.each_cell do |cell|
      next unless path_cell? cell

      unless path?(:cw, cell) || path?(:ccw, cell)
        # draw arc to close the gap if outward ring is subdivided
        # and cell is linked outwards but not cw and ccw
        # this can be the case even for cell(0,0)
        outward_cells = path_outward(cell)
        if outward_subdivided?(cell) && outward_cells.any?
          _, _, _, _, radius, angle = center_coord cell
          angles_outward_cells = outward_cells.map {|o| _, _, _, _, _, a = center_coord(o); a }
          # don't use cell(0,0) own angel, override with one of the outward cells
          angle = angles_outward_cells.first if cell.row == 0
          angle1 = [angle, *angles_outward_cells].min
          angle2 = [angle, *angles_outward_cells].max
          canvas.ellipse image_center, image_center, radius, radius, angle1, angle2 unless angle1 == angle2
        end
      end

      next if cell.row == 0
      
      if path?(:inward, cell)
        x1, y1, x2, y2, _, _ = center_coord cell
        canvas.line x1, y1, x2, y2
      end
      
      if path?(:cw, cell)
        _, _, _, _, radius1, angle1 = center_coord cell
        _, _, _, _, radius2, angle2 = center_coord cell.cw
        # adjust angle if outward ring is subdivided
        if outward_subdivided?(cell)
          outward_cells = path_outward(cell)
          _, _, _, _, _, angle1 = center_coord(outward_cells.first) if outward_cells.any?
          outward_cells_cw = path_outward(cell.cw)
          _, _, _, _, _, angle2 = center_coord(outward_cells_cw.first) if outward_cells_cw.any?
        end
        canvas.ellipse image_center, image_center, radius1, radius1, angle1, angle2
      end
    end
    
    # draw start and finish
    canvas.stroke_antialias true
    canvas.stroke_linecap 'square'
    canvas.fill path_color
    canvas.stroke 'none'
    [path_start, path_finish].compact.each do |cell|
      x, y, _, _, _, _ = center_coord cell
      canvas.ellipse x, y, path_width*2, path_width*2, 0, 360
    end
  end
  
  def outward_subdivided? cell
    return false if grid.rows == cell.row + 1
    grid.columns(cell.row).size != grid.columns(cell.row+1).size
  end
  
  def path_outward cell
    cell.outward.select {|o| cell.linked?(o) && path_cell?(o) }
  end
  
  def coord cell
    theta = 2 * Math::PI / grid.columns(cell.row).size
    inner_radius = cell.row * cell_width
    outer_radius = (cell.row + 1) * cell_width
    theta_ccw = cell.column * theta
    theta_cw = (cell.column + 1) * theta
    
    ax = image_center + inner_radius * Math.cos(theta_ccw)
    ay = image_center + inner_radius * Math.sin(theta_ccw)
    bx = image_center + outer_radius * Math.cos(theta_ccw)
    by = image_center + outer_radius * Math.sin(theta_ccw)
    cx = image_center + inner_radius * Math.cos(theta_cw)
    cy = image_center + inner_radius * Math.sin(theta_cw)
    dx = image_center + outer_radius * Math.cos(theta_cw)
    dy = image_center + outer_radius * Math.sin(theta_cw)
    
    theta_ccw_degres = 360 / (2 * Math::PI) * theta_ccw
    theta_cw_degres = 360 / (2 * Math::PI) * theta_cw
    
    [ax, ay, bx, by, cx, cy, dx, dy, inner_radius, theta_ccw_degres, theta_cw_degres]
  end
  
  def center_coord cell
    theta = 2 * Math::PI / grid.columns(cell.row).size

    angle = (cell.column + 0.5) * theta
    angle_degres = 360 / (2 * Math::PI) * angle

    radius1 = (cell.row + 0.5) * cell_width
    radius2 = (cell.row - 0.5) * cell_width

    x1 = image_center + radius1 * Math.cos(angle)
    y1 = image_center + radius1 * Math.sin(angle)
    x2 = image_center + radius2 * Math.cos(angle)
    y2 = image_center + radius2 * Math.sin(angle)
    
    [x1, y1, x2, y2, radius1, angle_degres]
  end
  
  def image_width
    cell_width * grid.rows * 2 + wall_width + border_width * 2 + 3 # why? +3
  end
  
  alias_method :image_height, :image_width
  
  def image_center
    image_width / 2
  end
end