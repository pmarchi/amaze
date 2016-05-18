
class Maze::Formatter::Image::Sigma < Maze::Formatter::Image
  
  def render_background
    canvas.stroke_antialias true
    canvas.stroke_linecap 'square'
    canvas.stroke 'none'
    grid.each_cell do |cell|
      color = distance_color cell
      next unless color
      canvas.fill color
      x1, x2, x3, x4, y1, y2, y3 = coord cell
      canvas.polygon x2, y1, x3, y1, x4, y2, x3, y3, x2, y3, x1, y2
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
      x1, x2, x3, x4, y1, y2, y3 = coord cell
      canvas.polygon x2, y1, x3, y1, x4, y2, x3, y3, x2, y3, x1, y2
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
      x1, x2, x3, x4, y1, y2, y3 = coord cell
      
      canvas.line x2, y1, x3, y1 unless cell.linked_to?(:north)
      canvas.line x3, y1, x4, y2 unless cell.linked_to?(:northeast)
      canvas.line x4, y2, x3, y3 unless cell.linked_to?(:southeast)
      canvas.line x2, y3, x3, y3 unless cell.linked_to?(:south)
      canvas.line x1, y2, x2, y3 unless cell.linked_to?(:southwest)
      canvas.line x1, y2, x2, y1 unless cell.linked_to?(:northwest)
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
      %i( northeast southeast south ).each do |direction|
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
    x, y = center_coord cell
    
    x1 = x - cell_width
    x2 = x - cell_width / 2.0
    x3 = x + cell_width / 2.0
    x4 = x + cell_width
    
    y1 = y - pattern_height / 2.0
    y2 = y
    y3 = y + pattern_height / 2.0

    [x1, x2, x3, x4, y1, y2, y3]
  end
  
  def center_coord cell
    row, column = cell.row, cell.column
    
    x = column * pattern_width + cell_width + cell_offset
    # add half or full height to find center
    row_offset = column.even? ? 0.5 : 1.0
    y = (row+row_offset) * pattern_height  + cell_offset
    
    [x, y]
  end
  
  def pattern_width
    @pattern_width ||= cell_width * 3 / 2.0
  end
  
  def pattern_height
    @pattern_height ||= cell_width * Math.sqrt(3)
  end
  
  def image_width
    pattern_width * grid.columns + cell_width / 2.0 + wall_width + border_width * 2 + 1
  end
  
  def image_height
    pattern_height * grid.rows + pattern_height / 2.0 + wall_width + border_width * 2 + 1
  end
end