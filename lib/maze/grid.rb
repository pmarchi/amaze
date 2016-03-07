
class Maze::Grid
  
  # The dimension of the maze
  attr_reader :rows, :columns
  
  # The grid
  attr_reader :grid
  
  # The size of the cell, when printed to the terminal
  attr_accessor :cell_size
  
  def initialize rows, columns
    @rows = rows
    @columns = columns
    
    @cell_size = 1
    
    prepare_grid
    configure_cell
  end
  
  def prepare_grid
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        Maze::Cell.new row, column
      end
    end
  end
  
  def configure_cell
    each_cell do |cell|
      row, column = cell.row, cell.column
      
      cell.north = self[row-1, column] 
      cell.east  = self[row, column+1]
      cell.south = self[row+1, column]
      cell.west  = self[row, column-1]
    end
  end
  
  def [](row, column)
    return nil unless row.between?(0, rows-1)
    return nil unless column.between?(0, columns-1)
    grid[row][column]
  end
  
  def each_row
    grid.each do |row|
      yield row
    end
  end
  
  def each_cell
    each_row do |row|
      row.each do |cell|
        yield cell
      end
    end
  end

  def random_cell
    self[rand(rows), rand(columns)]
  end

  def size
    rows * columns
  end

  def to_s marked_cell=nil
    output = "\e[H\e[2J" # clear screen
    output += "+" + ("-" * cell_size * 3 + "+") * columns + "\n"
    
    each_row do |row|
      top = "|"
      marked = "|"
      bottom = "+"
      
      row.each do |cell|
        body = " " * cell_size * 3
        east_boundary = cell.linked?(cell.east) ? ' ' : '|'
        top << body << east_boundary
        
        if cell == marked_cell
          body = "*".center(cell_size * 3)
        end
        marked << body << east_boundary
        
        south_boundary = (cell.linked?(cell.south) ? ' ' : '-') * cell_size * 3
        corner = "+"
        bottom << south_boundary << corner
      end
      
      cell_size.times do |i|
        if cell_size/2 == i
          output << marked << "\n"
        else
          output << top << "\n"
        end
      end
      output << bottom << "\n"
      
    end
    
    output
  end
end