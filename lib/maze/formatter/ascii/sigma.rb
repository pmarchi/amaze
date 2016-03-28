
class Maze::Formatter::ASCII::Sigma < Maze::Formatter::ASCII

  def render
    output = ansi_clear

    # top row
    repeat = ((grid.columns + 0.5) / 2).round - 1
    output << " " * cell_size << line
    output << (" " * cell_size * 2 + space + line) * repeat << "\n"
    
    grid.each_row do |row|
      upper = Array.new(cell_size) { "" }
      lower = Array.new(cell_size) { "" }
      
      cell_size.times do |i|
        upper[i] << " " * (cell_size-1-i) << upper_west
        lower[i] << " " * i << lower_west
      end

      row.each do |cell|
        cell_size.times do |i|
          north = " " * i
          if i == cell_size-1
            north << content_of(cell).center(cell_size * 3).send(content_color_of(cell))
          else
            north << space
          end
          north << " " * i
          north_east = (cell.linked? cell.northeast) ? empty_side : upper_east

          if cell.column.even?
            south = (i < (cell_size-1) || cell.linked?(cell.south)) ? space + " " * (cell_size-1-i) * 2 : line
            south_east = (cell.linked? cell.southeast) ? empty_side : lower_east

            upper[i] << north << north_east   # upper half of cell
            lower[i] << south << south_east   # lower half of cell
          else
            south = (i < (cell_size-1) || cell.linked?(cell.north)) ? space + " " * (cell_size-1-i) * 2 : line
            south_east = (cell.north || cell.northeast) ? 
              (cell.north && cell.north.linked?(cell.northeast)) ? 
                empty_side : 
                lower_east :
              ""

            upper[i] << south << south_east   # lower half of cell from row above
            lower[i] << north << north_east   # upper half of cell from current row
          end
        end
      end
      
      cell_size.times {|i| output << upper[i] << "\n" }
      cell_size.times {|i| output << lower[i] << "\n" }
    end
    
    # last lower half of cells
    repeat = grid.columns / 2
    cell_size.times do |i|
      south = (i < (cell_size-1)) ? space : line
      output << " " * (cell_size-i)
      output << (" " * i * 2 + space + lower_west + " " * (cell_size-1-i) * 2 + south + lower_east) * repeat
      output << "\n"
    end

    output
  end
  
  def line
    "___" * cell_size
  end
  
  def space
    "   " * cell_size
  end

  def upper_east
    "\\"
  end

  def lower_east
    "/"
  end
  
  def upper_west
    "/"
  end
  
  def lower_west
    "\\"
  end
  
  def empty_side
    " "
  end
end