
class Amaze::Shape::Diamond < Amaze::Shape

  def build_mask
    (0...size).each do |row|
      # How many cells are on
      on = (row+1) * 2 - 1
      # How many cells are off
      off = (columns - on) / 2
      # Build a line: #off cells, #on cells, #off cells
      line_map = Array.new(off, false) + Array.new(on, true) + Array.new(off, false)
      line_map.each_with_index do |switch, i|
        mask[row, i] = switch
        mask[rows-row-1,i] = switch
      end
    end
  end
  
  def rows
    size * 2
  end
  
  def columns
    (size+1)/2 * 4 - 1
  end
end