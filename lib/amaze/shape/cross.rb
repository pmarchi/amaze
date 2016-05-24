
class Amaze::Shape::Cross < Amaze::Shape
  
  label :cross
  
  def chars
    lines = Array.new(rows)
    
    (0...size).each do |row|
      lines[row] = off(size) + on(size) + off(size)
      lines[row+size] = on(columns)
      lines[row+size*2] = lines[row]
    end
    
    lines
  end

  def rows
    size * 3
  end
  
  alias_method :columns, :rows
end