
class Maze::Shape::Hexagon < Maze::Shape

  def build_mask
    (0...size).each do |row|
      # How many cells are on
      on = size * 2 + 1 + row * 2
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
    (size-1) * 4 + 3 + offset * 2
  end

  def offset
    size.even? ? 0 : 1
  end
end

__END__

1  3
2  5
3  7
4  9
5 11


1
X...X
X...X

2
X.....X
.......
.......
X.....X

3
XXX.......XXX
XX.........XX
X...........X
X...........X
XX.........XX
XXX.......XXX

4
XXX.........XXX
XX...........XX
X.............X
...............
...............
X.............X
XX...........XX
XXX.........XXX

5
XXXXX...........XXXXX
XXXX.............XXXX
XXX...............XXX
XX.................XX
X...................X
X...................X
XX.................XX
XXX...............XXX
XXXX.............XXXX
XXXXX...........XXXXX