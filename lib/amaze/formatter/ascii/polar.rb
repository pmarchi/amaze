
class Amaze::Formatter::ASCII::Polar < Amaze::Formatter::ASCII
  
  def draw_cell cell
    x1, x2, y1, y2 = coord cell
    
    # corners
    char[y1][x1] = corner.color(grid_color)
    char[y1][x2] = corner.color(grid_color)
    char[y2][x1] = corner.color(grid_color)
    char[y2][x2] = corner.color(grid_color)
    # top & bottom
    (x1+1).upto(x2-1) do |i|
      # top (inward)
      char[y1][i] = h.color(grid_color) unless cell.linked_to?(:inward)
      # bottom (outward)
      char[y2][i] = h.color(grid_color) if cell.row == grid.rows-1
    end
    # left & right
    (y1+1).upto(y2-1) do |i|
      # left (cw)
      char[i][x1] = v.color(grid_color) unless cell.linked_to?(:cw)
      # right (ccw)
      char[i][x2] = v.color(grid_color) unless cell.linked_to?(:ccw)
    end
  end

  def draw_content cell
    x1, x2, _, _ = coord cell
    _, my = center_coord cell
    dx = x2 - x1 - 1 

    distance(cell).center(dx).chars.each_with_index do |c,i|
      char[my][x1+1+i] = c.color(*distance_color(cell))
    end
  end

  def draw_path cell
    # draw horizontal connections in cells with more than one outward path
    if outward_subdivided?(cell) && ! path?(:cw, cell) && ! path?(:ccw, cell)
      outward_cells = path_outward(cell)
      if outward_cells.any?
        mx, my = center_coord cell
        x_outward_cells = outward_cells.map{|c| x,_ = center_coord c; x}
        mx = x_outward_cells.first if cell.row.zero?
        mx_min = [mx, *x_outward_cells].min
        mx_max = [mx, *x_outward_cells].max
        char[my][mx_min] = center.color(path_color)
        char[my][mx_max] = center.color(path_color)
        (mx_min+1).upto(mx_max-1) do |i|
          char[my][i] = h.color(path_color)
        end
      end
    end
    
    # to cw
    if path?(:cw, cell)
      mx1, my1 = center_coord cell.cw
      mx2, _ = center_coord cell
      if outward_subdivided? cell
        outward_cells_cw = path_outward cell.cw
        mx1, _ = center_coord(outward_cells_cw.first) if outward_cells_cw.any?
        outward_cells = path_outward cell
        mx2, _ = center_coord(outward_cells.first) if outward_cells.any?
      end
      mx1 = -1 if mx1 > mx2
      (mx1+1).upto(mx2-1) do |i|
        char[my1][i] = h.color(path_color)
      end
      char[my1][mx2] = center.color(path_color)
    end
    
    # to ccw
    if path?(:ccw, cell)
      mx1, my1 = center_coord cell
      mx2, _ = center_coord cell.ccw
      if outward_subdivided? cell
        outward_cells = path_outward cell
        mx1, _ = center_coord(outward_cells.first) if outward_cells.any?
        outward_cells_ccw = path_outward cell.ccw
        mx2, _ = center_coord(outward_cells_ccw.first) if outward_cells_ccw.any?
      end
      mx2 = char_array_width if mx1 > mx2
      (mx1+1).upto(mx2-1) do |i|
        char[my1][i] = h.color(path_color)
      end
      char[my1][mx1] = center.color(path_color)
    end
    
    # to inward
    if path?(:inward, cell)
      mx, my = center_coord cell
      _, _, w1, w2 = coord cell.inward
      mw = (w1 + w2) / 2
      (mw+1).upto(my-1) do |i|
        char[i][mx] = v.color(path_color)
      end
    end

    # center
    mx, my = center_coord cell
    if outward_subdivided? cell
      char[my][mx] = h.color(path_color) if path?(:ccw, cell) && path?(:cw, cell)
      char[my][mx] = center.color(path_color) if path?(:inward, cell) && path_outward(cell).empty?
    else
      center_char = center
      center_char = h if path?(:ccw, cell) && path?(:cw, cell)
      center_char = v if path?(:inward, cell) && path_outward(cell).any?
      char[my][mx] = center_char.color(path_color)
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
    columns = grid.columns(cell.row).size
    x2 = char_array_width - 1 - x(cell.column, columns)
    x1 = char_array_width - 1 - x(cell.column+1, columns)
    y1 = y(cell.row)
    y2 = y(cell.row+1)
    
    [x1, x2, y1, y2]
  end
  
  def center_coord cell
    x1, x2, y1, y2 = coord cell
    [(x1 + x2) / 2, (y1 + y2) / 2]
  end
  
  def x column, columns=max_columns
    factor = max_columns / columns
    (cell_size * 4 * factor) * column
  end
  
  def y row
    (cell_size + 1) * row
  end
  
  def max_columns
    grid.columns(grid.rows-1).size
  end
  
  def char_array_width
    x(max_columns) + 1
  end
  
  def char_array_height
    y(grid.rows) + 1
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

__END__

+-----------------------------------------------+ 47   f=12  columns/column * 3 + columns/column-1
|                                               |
+---------------+---------------+---------------+ 15   f=4
|               |               |               |
+-------+-------+-------+-------+-------+-------+ 7    f=2
|       |       |       |       |       |       |
+---+---+---+---+---+---+---+---+---+---+---+---+ 3    f=1
|   |   |   |   |   |   |   |   |   |   |   |   |
+---+---+---+---+---+---+---+---+---+---+---+---+

+-----------------------------------------------------------------------------------+
|                                                                                   |
|                                                                                   |
+---------------------------+---------------------------+---------------------------+
|                           |                           |                           |
|                           |                           |                           |
+-------------+-------------+-------------+-------------+-------------+-------------+
|             |             |             |             |             |             |
|             |             |             |             |             |             |
+------+------+------+------+------+------+------+------+------+------+------+------+
|      |      |      |      |      |      |      |      |      |      |      |      |
|      |      |      |      |      |      |      |      |      |      |      |      |
+------+------+------+------+------+------+------+------+------+------+------+------+