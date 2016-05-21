
class Amaze::Grid::Polar < Amaze::Grid
  
  def initialize rows
    super rows, 1
  end

  def prepare_grid
    @grid = Array.new(rows)
    @grid[0] = [Amaze::Cell::Polar.new(0, 0)]
    
    row_height = 1.0 / rows
    (1...rows).each do |row|
      radius = row.to_f / rows
      circumference = 2 * Math::PI * radius
      
      previous_count = @grid[row-1].size
      estimated_cell_width = circumference / previous_count
      ratio = (estimated_cell_width / row_height).round
      
      cells = previous_count * ratio
      @grid[row] = Array.new(cells) {|column| Amaze::Cell::Polar.new(row, column) }
    end
  end
  
  def configure_cell
    each_cell do |cell|
      row, column = cell.row, cell.column
      next if row == 0
      
      cell.cw = self[row, column+1]
      cell.ccw = self[row, column-1]
      
      ratio = grid[row].size / grid[row-1].size
      parent = self[row-1, column/ratio]
      parent.outward << cell
      cell.inward = parent
    end
  end
  
  def columns row
    grid[row]
  end
  
  def [](row, column)
    return nil unless row.between?(0, rows-1)
    grid[row][column % columns(row).size]
  end
  
  def random_cell
    row = rand rows
    column = rand grid[row].size
    self[row, column]
  end
  
  def size
    count = 0
    each_row {|row| count += row.size }
    count
  end
end
