
class Amaze::Shape::Triangle < Amaze::Shape

  label :triangle

  def chars
    Array.new(rows) do |row|
      # How many cells are on
      n_on = row * 2 + 1
      # How many cells are off
      n_off = (columns - n_on) / 2
      # Build the line of cells
      off(n_off) + on(n_on) + off(n_off)
    end
  end
  
  def rows
    size
  end
  
  def columns
    size * 2 - 1 + offset
  end
  
  def offset
    size.even? ? 0 : 2
  end
end