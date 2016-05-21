
class Amaze::Formatter::Image::Upsilon < Amaze::Formatter::Image
  
  def render_background
    canvas.stroke_antialias true
    canvas.stroke_linecap 'round'
    canvas.stroke_linejoin 'round'
    canvas.stroke 'none'
    grid.each_cell do |cell|
      color = distance_color cell
      next unless color
      canvas.fill color
      canvas.polygon *coord(cell)
    end
  end
  
  def render_grid
    canvas.stroke_antialias true
    canvas.stroke_linecap 'round'
    canvas.stroke_linejoin 'round'
    canvas.stroke 'gray90'
    canvas.stroke_width 1
    canvas.fill 'none'

    grid.each_cell do |cell|
      canvas.polygon *coord(cell)
    end
  end
  
  def render_wall
    canvas.stroke_antialias true
    canvas.stroke_linecap 'round'
    canvas.stroke_linejoin 'round'
    canvas.stroke wall_color
    canvas.stroke_width wall_width
    canvas.fill 'none'

    grid.each_cell do |cell|
      ax, ay, bx, by, cx, cy, dx, dy, ex, ey, fx, fy, gx, gy, hx, hy = coord cell
      
      if (cell.row + cell.column).even?
        # octo cells
        canvas.line ax, ay, bx, by unless cell.linked_to?(:north)
        canvas.line bx, by, cx, cy unless cell.linked_to?(:northeast)
        canvas.line cx, cy, dx, dy unless cell.linked_to?(:east)
        canvas.line dx, dy, ex, ey unless cell.linked_to?(:southeast)
        canvas.line ex, ey, fx, fy unless cell.linked_to?(:south)
        canvas.line fx, fy, gx, gy unless cell.linked_to?(:southwest)
        canvas.line gx, gy, hx, hy unless cell.linked_to?(:west)
        canvas.line hx, hy, ax, ay unless cell.linked_to?(:northwest)
      else
        # square cells
        canvas.line ax, ay, bx, by unless cell.linked_to?(:north)
        canvas.line bx, by, cx, cy unless cell.linked_to?(:east)
        canvas.line cx, cy, dx, dy unless cell.linked_to?(:south)
        canvas.line dx, dy, ax, ay unless cell.linked_to?(:west)
      end
    end
  end
  
  def render_path
    canvas.stroke_antialias true
    canvas.stroke_linecap 'round'
    canvas.stroke_linejoin 'round'
    canvas.fill 'none'
    canvas.stroke path_color
    canvas.stroke_width path_width
    
    grid.each_cell do |cell|
      next unless path_cell? cell

      x1, y1 = center_coord cell
      %i( north northeast east southeast ).each do |direction|
        # square cells don't respond to northeast and southeast
        next unless cell.respond_to? direction
        next unless path?(direction, cell)
        x2, y2 = center_coord cell.send(direction)
        canvas.line x1, y1, x2, y2
      end
    end

    # draw start and finish
    canvas.stroke_antialias true
    canvas.stroke_linecap 'round'
    canvas.fill path_color
    canvas.stroke 'none'
    [path_start, path_finish].compact.each do |cell|
      x, y = center_coord cell
      canvas.ellipse x, y, path_width*2, path_width*2, 0, 360
    end
  end
  
  def coord cell
    row, column = cell.row, cell.column
    
    x1 = column * pattern_width + cell_offset
    x2 = x1 + partial_cell
    x3 = x2 + cell_width
    x4 = x3 + partial_cell
    
    y1 = row * pattern_width + cell_offset
    y2 = y1 + partial_cell
    y3 = y2 + cell_width
    y4 = y3 + partial_cell

    if (row+column).even?
      [x2, y1, x3, y1, x4, y2, x4, y3, x3, y4, x2, y4, x1, y3, x1, y2]
    else
      [x2, y2, x3, y2, x3, y3, x2, y3]
    end
  end
  
  def center_coord cell
    row, column = cell.row, cell.column
    
    d = partial_cell + cell_width / 2.0
    x = column * pattern_width + d + cell_offset
    y = row * pattern_width + d + cell_offset
    [x, y]
  end
  
  def partial_cell
    @partial_cell ||= cell_width * Math.sqrt(2) / 2.0
  end
  
  def pattern_width
    @pattern_width ||= cell_width + partial_cell
  end
  
  def image_width
    pattern_width * (grid.columns) + partial_cell + wall_width + border_width * 2 + 1
  end
  
  alias_method :image_height, :image_width
end