
class Maze::Formatter::PNG::Ortho < Maze::Formatter::PNG
  
  def background_color
    ChunkyPNG::Color::WHITE
  end
  
  def wall_color
    ChunkyPNG::Color::BLACK
  end
  
  # The image object
  attr_reader :image
  
  def render grid
    image_width = cell_size * grid.columns + border * 2 + thickness
    image_height = cell_size * grid.rows + border * 2 + thickness

    @image = ChunkyPNG::Image.new image_width, image_height, background_color
    
    grid.each_cell do |cell|
      x1, y1, x2, y2 = coordinates cell
      
      horizontal_line x1, x2, y1, wall_color, thickness unless cell.north
      vertical_line   x1, y1, y2, wall_color, thickness unless cell.west

      vertical_line   x2, y1, y2, wall_color, thickness unless cell.linked? cell.east
      horizontal_line x1, x2, y2, wall_color, thickness unless cell.linked? cell.south
    end
    
    image
  end
  
  def horizontal_line x1, x2, y, color, thickness
    v_offset = thickness / 2
    thickness.times do |i|
      h_offset = i - thickness / 2
      image.line x1-v_offset, y+h_offset, x2+v_offset, y+h_offset, wall_color
    end
  end
  
  def vertical_line x, y1, y2, color, thickness
    h_offset = thickness / 2
    thickness.times do |i|
      v_offset = i - thickness / 2
      image.line x+v_offset, y1-h_offset, x+v_offset, y2+h_offset, wall_color
    end
  end
  
  def coordinates cell
    offset = border + thickness / 2
    [
      cell.column * cell_size + offset,
      cell.row * cell_size + offset,
      (cell.column + 1) * cell_size + offset,
      (cell.row + 1) * cell_size + offset,
    ]
  end
end