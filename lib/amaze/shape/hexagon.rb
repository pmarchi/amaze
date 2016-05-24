
class Amaze::Shape::Hexagon < Amaze::Shape
  
  label :hexagon

  def chars
    lines = Array.new(rows)

    (0...size).each do |row|
      # How many cells are on
      n_on = rows + 1 + row * 2
      # How many cells are off
      n_off = (columns - n_on) / 2
      lines[row] = off(n_off) + on(n_on) + off(n_off)
      lines[rows-1-row] = lines[row]
    end

    lines
  end
  
  def rows
    size * 2
  end
  
  def columns
    size * 4 - 1 + offset
  end

  def offset
    size.even? ? 0 : 2
  end
end
