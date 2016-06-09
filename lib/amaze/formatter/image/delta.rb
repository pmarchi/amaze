
class Amaze::Formatter::Image::Delta < Amaze::Formatter::Image
  include Amaze::Formatter::Image::Setup
  
  def canvas_options
    {linecap: 'round', linejoin: 'round'}
  end
  
  def render_background
    setup_background

    grid.each_cell do |cell|
      color = distance_color cell
      next unless color
      canvas.fill color
      canvas.polygon(*coord(cell))
    end
  end
  
  def render_grid
    setup_grid

    grid.each_cell do |cell|
      canvas.polygon(*coord(cell))
    end
  end
  
  def render_wall
    setup_wall

    grid.each_cell do |cell|
      ax, ay, bx, by, cx, cy = coord cell
      
      canvas.line ax, ay, cx, cy unless cell.linked_to?(:west)
      canvas.line bx, by, cx, cy unless cell.linked_to?(:east)

      direction = (cell.row+cell.column).even? ? :north : :south
      canvas.line ax, ay, bx, by unless cell.linked_to?(direction)
    end
  end
  
  def render_path
    setup_path
    
    grid.each_cell do |cell|
      next unless path_cell? cell

      x1, y1 = center_coord cell
      %i( north east ).each do |direction|
        next unless path?(direction, cell)
        x2, y2 = center_coord cell.send(direction)
        canvas.line x1, y1, x2, y2
      end
    end

    # draw start and finish
    setup_path_endpoints

    [path_start, path_finish].compact.each do |cell|
      x, y = center_coord cell
      canvas.ellipse x, y, path_width*2, path_width*2, 0, 360
    end
  end
  
  def coord cell
    row, column = cell.row, cell.column

    x1 = column * pattern_width + cell_offset
    y1 = row * pattern_height + cell_offset
    x2 = x1 + pattern_width
    x3 = x2 + pattern_width
    y2 = y1 + pattern_height
    
    if (row+column).even?
      [x1, y1, x3, y1, x2, y2]
    else
      [x1, y2, x3, y2, x2, y1]
    end
  end
  
  def center_coord cell
    row, column = cell.row, cell.column
    
    x = (column+1) * pattern_width + cell_offset
    y0 = row * pattern_height + cell_offset
    
    dy = cell_width * Math.sqrt(3)
    fraction = (row+column).even? ? 6.0 : 3.0
    y = y0 + dy / fraction
    
    [x, y]
  end
  
  def pattern_width
    @pattern_width ||= cell_width / 2.0
  end
  
  def pattern_height
    @pattern_height ||= cell_width * Math.sqrt(3) / 2.0
  end
  
  def image_width
    pattern_width * (grid.columns + 1) + wall_width + border_width * 2 + 1
  end
  
  def image_height
    pattern_height * grid.rows + wall_width + border_width * 2 + 1
  end
end