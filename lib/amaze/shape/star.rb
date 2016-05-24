
class Amaze::Shape::Star < Amaze::Shape
  
  label :star

  def chars
    lines = Array.new(rows)
    
    (0...size).each do |row|
      # top section
      n_on = row * 2 + 1
      n_off = (columns - n_on) / 2
      # upper triangle
      lines[row] = off(n_off) + on(n_on) + off(n_off)
      # lower triangle
      lines[rows-1-row] = lines[row]

      # middle section
      n_on = columns - offset - row * 2
      n_off = (columns - n_on) / 2
      # middle upper section
      lines[row + size] = off(n_off) + on(n_on) + off(n_off)
      # middle lower section
      lines[rows-1-size-row] = lines[row+size]
    end
    
    lines
  end
  
  def rows
    size * 4
  end
  
  def columns
    size * 6 - 1 + offset
  end
  
  def offset
    size.even? ? 0 : 2
  end
end
