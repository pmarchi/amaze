
class Maze::Formatter::Image::Ortho < Maze::Formatter::Image
  
  def render_background
  end
  
  def render_wall
    canvas.stroke_antialias true
    canvas.stroke_linecap 'square'
    canvas.fill 'none'

    # raster
    if show_grid?
      canvas.stroke 'gray90'
      canvas.stroke_width 1
      grid.each_cell do |cell|
        x1, x2, y1, y2 = coord cell
      
        canvas.line x1, y1, x2, y1
        canvas.line x2, y1, x2, y2
        canvas.line x1, y2, x2, y2
        canvas.line x1, y1, x1, y2
      end
    end

    # maze
    canvas.stroke wall_color
    canvas.stroke_width wall_width
    grid.each_cell do |cell|
      x1, x2, y1, y2 = coord cell
      
      canvas.line x1, y1, x2, y1 unless cell.linked_to?(:north)
      canvas.line x2, y1, x2, y2 unless cell.linked_to?(:east)
      canvas.line x1, y2, x2, y2 unless cell.linked_to?(:south)
      canvas.line x1, y1, x1, y2 unless cell.linked_to?(:west)
    end
  end
  
  def render_path
    canvas.stroke_antialias true
    canvas.stroke_linecap 'square'
    canvas.fill 'none'
    canvas.stroke path_color
    canvas.stroke_width path_width
    
    grid.each_cell do |cell|
      next unless path_cell? cell

      x1, y1 = center_coord cell
      # east-west
      if path?(:east, cell)
        x2, y2 = center_coord cell.east
        canvas.line x1, y1, x2, y2
      end
      # north-south
      if path?(:south, cell)
        x2, y2 = center_coord cell.south
        canvas.line x1, y1, x2, y2
      end
    end

    # draw start and finish
    canvas.stroke_antialias true
    canvas.stroke_linecap 'square'
    canvas.fill path_color
    canvas.stroke 'none'
    [path_start, path_finish].compact.each do |cell|
      x, y = center_coord cell
      canvas.ellipse x, y, path_width*2, path_width*2, 0, 360
    end
  end
  
  def coord cell
    row, column = cell.row, cell.column
    
    x1 = column * cell_width + cell_offset
    x2 = (column+1) * cell_width + cell_offset
    y1 = row * cell_width + cell_offset
    y2 = (row+1) * cell_width + cell_offset
    
    [x1, x2, y1, y2]
  end
  
  def center_coord cell
    row, column = cell.row, cell.column
    
    x = (column+0.5) * cell_width + cell_offset
    y = (row+0.5) * cell_width + cell_offset
    
    [x, y]
  end
  
  def cell_offset
    wall_width / 2.0 + border_width
  end
  
  def image_width
    cell_width * grid.columns + wall_width + border_width * 2 + 1
  end
  
  def image_height
    cell_width * grid.rows + wall_width + border_width * 2 + 1
  end
end