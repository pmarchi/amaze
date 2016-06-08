
class Amaze::Formatter::ASCII::Sigma < Amaze::Formatter::ASCII
  include Amaze::Formatter::ASCII::HexHelper

  def draw_cell cell
    x, y = coord cell
    
    h6_wall.each_with_index do |c,i|
      # north
      char[y][x+ox+i] = c.color(grid_color) unless cell.linked_to?(:north)
      # south
      char[y+dy][x+ox+i] = c.color(grid_color) unless cell.linked_to?(:south)
    end
    
    db6_wall.each_with_index do |c,i|
      # northeast
      char[y+1+i][x+dx+i] = c.color(grid_color) unless cell.linked_to?(:northeast)
      # southwest
      char[y+oy+1+i][x+i] = c.color(grid_color) unless cell.linked_to?(:southwest)
    end
    
    df6_wall.each_with_index do |c,i|
      # northwest
      char[y+1+i][x+ox-i-1] = c.color(grid_color) unless cell.linked_to?(:northwest)
      # southeast
      char[y+oy+1+i][x+dx+ox-i-1] = c.color(grid_color) unless cell.linked_to?(:southeast)
    end
  end
  
  def draw_distance_coord cell
    x, y = coord cell
    [x + ox, y + oy, dx - ox]
  end

  def draw_path cell
    x, y = center_coord cell
    # north-south
    v6_path.each_with_index do |c,i|
      char[y+i][x] = c.color(path_color)
    end if path?(:south, cell)
    
    d6_path_i.each_with_index do |yi, i|
      # southwest-northeast
      char[y+yi][x-i*2] = df6_path[i].color(path_color) if path?(:southwest, cell)
      # southeast-northwest
      char[y+yi][x+i*2] = db6_path[i].color(path_color) if path?(:southeast, cell)
    end
  end
  
  def coord cell
    [cell.column * dx, cell.row * dy + (cell.column.odd? ? oy : 0)]
  end
  
  def center_coord cell
    x, y = coord cell
    [x + (dx + oy - 1) / 2, y + oy]
  end
  
  def dx
    cell_size * 4
  end
  
  def dy
    cell_size * 2
  end
  
  def ox
    cell_size
  end
  
  alias_method :oy, :ox
    
  def char_array_width
    grid.columns * dx + cell_size
  end
  
  def char_array_height
    grid.rows * dy + cell_size + 1
  end
end
