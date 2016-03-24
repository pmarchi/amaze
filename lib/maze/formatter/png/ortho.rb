
class Maze::Formatter::PNG::Ortho < Maze::Formatter::PNG
  
  def background_color
    ChunkyPNG::Color::WHITE
  end
  
  def wall_color
    ChunkyPNG::Color.html_color(:black)
  end
  
  # The image object
  attr_reader :image
  
  def render grid
    image_width = cell_size * grid.columns + border * 2 + line_width
    image_height = cell_size * grid.rows + border * 2 + line_width

    @image = ChunkyPNG::Image.new image_width, image_height, background_color
    
    grid.each_cell do |cell|
      x1, y1, x2, y2 = coordinates cell
      
      orthogonal_line x1, x2, y1, y1, wall_color, line_width unless cell.north
      orthogonal_line x1, x1, y1, y2, wall_color, line_width unless cell.west

      orthogonal_line x2, x2, y1, y2, wall_color, line_width unless cell.linked? cell.east
      orthogonal_line x1, x2, y2, y2, wall_color, line_width unless cell.linked? cell.south
    end
    
    image
  end
  
  def orthogonal_line x1, x2, y1, y2, color, width
    length_offset = line_width / 2
    width.times do |w|
      position_offset = w - width / 2
      if x1 == x2
        # vertical line
        image.line x1+position_offset, y1-length_offset, x2+position_offset, y2+length_offset, wall_color
      else
        # horizontal line
        image.line x1-length_offset, y1+position_offset, x2+length_offset, y2+position_offset, wall_color
      end
    end
  end

  def coordinates cell
    offset = border + line_width / 2
    [
      cell.column * cell_size + offset,
      cell.row * cell_size + offset,
      (cell.column + 1) * cell_size + offset,
      (cell.row + 1) * cell_size + offset,
    ]
  end
end