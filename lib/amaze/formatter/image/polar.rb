
class Amaze::Formatter::Image::Polar < Amaze::Formatter::Image
  include Amaze::Formatter::Image::Setup
  
  def canvas_options
    {linecap: 'square'}
  end
  
  def render_background
    canvas.stroke_antialias true
    canvas.stroke_linecap 'butt'
    canvas.stroke_width cell_width
    canvas.fill 'none'

    grid.each_cell do |cell|
      color = distance_color cell
      next unless color
      canvas.stroke color
      _, _, _, _, _, ccw, cw = coord cell
      radius, _ = center_coord cell
      canvas.ellipse image_center, image_center, radius, radius, ccw, cw
    end
  end
  
  def render_grid
    setup_grid

    grid.each_cell do |cell|
      next if cell.row == 0
      cx, cy, dx, dy, radius, ccw, cw = coord cell
  
      canvas.ellipse image_center, image_center, radius, radius, ccw, cw
      canvas.line cx, cy, dx, dy
    end
    canvas.ellipse(image_center, image_center, grid.rows * cell_width, grid.rows * cell_width, 0, 360)
  end
  
  def render_wall
    setup_wall

    grid.each_cell do |cell|
      next if cell.row == 0
      cx, cy, dx, dy, radius, ccw, cw = coord cell
      
      canvas.ellipse image_center, image_center, radius, radius, ccw, cw unless cell.linked_to?(:inward)
      canvas.line cx, cy, dx, dy unless cell.linked_to?(:cw)
    end
    
    canvas.ellipse(image_center, image_center, grid.rows * cell_width, grid.rows * cell_width, 0, 360)
  end
  
  def render_path
    setup_path

    grid.each_cell do |cell|
      next unless path_cell? cell

      unless path?(:cw, cell) || path?(:ccw, cell)
        # draw arc to close the gap if outward ring is subdivided
        # and cell is linked outwards but not cw and ccw
        # this can be the case even for cell(0,0)
        outward_cells = path_outward(cell)
        if outward_subdivided?(cell) && outward_cells.any?
          radius, angle = center_coord cell
          angles_outward_cells = outward_cells.map {|o| _, a = center_coord(o); a }
          # don't use cell(0,0) own angel, override with one of the outward cells
          angle = angles_outward_cells.first if cell.row == 0
          angle1 = [angle, *angles_outward_cells].min
          angle2 = [angle, *angles_outward_cells].max
          canvas.ellipse image_center, image_center, radius, radius, angle1, angle2 unless angle1 == angle2
        end
      end

      next if cell.row == 0
      
      if path?(:inward, cell)
        radius, theta = center_coord cell, :radian
        # center of cell
        x1, y1 = polar2cartesian(radius, theta)
        # center of inward cell, but adjusted to the same angle of the current cell
        radius_inward, _ = center_coord cell.inward, :radian
        x2, y2 = polar2cartesian(radius_inward, theta)
        canvas.line x1, y1, x2, y2
      end
      
      if path?(:cw, cell)
        radius1, angle1 = center_coord cell
        _, angle2 = center_coord cell.cw
        # adjust angle if outward ring is subdivided
        if outward_subdivided?(cell)
          outward_cells = path_outward(cell)
          _, angle1 = center_coord(outward_cells.first) if outward_cells.any?
          outward_cells_cw = path_outward(cell.cw)
          _, angle2 = center_coord(outward_cells_cw.first) if outward_cells_cw.any?
        end
        canvas.ellipse image_center, image_center, radius1, radius1, angle1, angle2
      end
    end
    
    # draw start and finish
    setup_path_endpoints

    [path_start, path_finish].compact.each do |cell|
      radius, theta = center_coord cell, :radian
      # adjust the angle for cell(0,0)
      _, theta = center_coord path_outward(cell).first, :radian if cell.row.zero?
      x, y = polar2cartesian(radius, theta)
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
  
  def coord cell, unit=:degree
    inner_radius = cell.row * cell_width
    outer_radius = (cell.row + 1) * cell_width
    theta = 2 * Math::PI / grid.columns(cell.row).size
    theta_ccw = cell.column * theta
    theta_cw = (cell.column + 1) * theta
    
    # we need only the cartesian coords of the cw wall
    # ax, ay = polar2cartesian(inner_radius, theta_ccw)
    # bx, by = polar2cartesian(outer_radius, theta_ccw)
    cx, cy = polar2cartesian(inner_radius, theta_cw)
    dx, dy = polar2cartesian(outer_radius, theta_cw)
    
    if unit == :degree
      theta_ccw = radian2degree theta_ccw
      theta_cw = radian2degree theta_cw
    end
    
    [cx, cy, dx, dy, inner_radius, theta_ccw, theta_cw]
  end

  def center_coord cell, unit=:degree
    radius = (cell.row + 0.5) * cell_width
    theta = 2 * Math::PI / grid.columns(cell.row).size
    angle = (cell.column + 0.5) * theta
    angle = radian2degree(angle) if unit == :degree

    [radius, angle]
  end
  
  def polar2cartesian radius, theta
    [image_center + radius * Math.cos(theta), image_center + radius * Math.sin(theta)]
  end
  
  def radian2degree value
    360 / (2 * Math::PI) * value
  end
  
  def image_width
    cell_width * grid.rows * 2 + wall_width + border_width * 2 + 3 # why? +3
  end
  
  alias_method :image_height, :image_width
  
  def image_center
    image_width / 2
  end
end