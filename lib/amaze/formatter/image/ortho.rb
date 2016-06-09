
class Amaze::Formatter::Image::Ortho < Amaze::Formatter::Image
  include Amaze::Formatter::Image::Setup
  
  def canvas_options
    {linecap: 'square'}
  end

  def render_background
    setup_background

    grid.each_cell do |cell|
      color = distance_color cell
      next unless color
      canvas.fill color
      x1, x2, y1, y2 = coord cell
      canvas.polygon x1, y1, x2, y1, x2, y2, x1, y2
    end
  end
  
  def render_grid
    setup_grid

    grid.each_cell do |cell|
      x1, x2, y1, y2 = coord cell
      canvas.polygon x1, y1, x2, y1, x2, y2, x1, y2
    end
  end  

  def render_wall
    setup_wall

    grid.each_cell do |cell|
      x1, x2, y1, y2 = coord cell
      
      canvas.line x1, y1, x2, y1 unless cell.linked_to?(:north)
      canvas.line x2, y1, x2, y2 unless cell.linked_to?(:east)
      canvas.line x1, y2, x2, y2 unless cell.linked_to?(:south)
      canvas.line x1, y1, x1, y2 unless cell.linked_to?(:west)
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
  
  def image_width
    cell_width * grid.columns + wall_width + border_width * 2 + 1
  end
  
  def image_height
    cell_width * grid.rows + wall_width + border_width * 2 + 1
  end
end