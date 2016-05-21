
class Amaze::Shape::Star < Amaze::Shape

  def build_mask
    (0...size).each do |row|
      # top section
      on = row * 2 + 1
      off = (columns - on) / 2
      # Build a line: #off cells, #on cells, #off cells
      line_map = Array.new(off, false) + Array.new(on, true) + Array.new(off, false)
      line_map.each_with_index do |switch, i|
        # upper triangle
        mask[row, i] = switch
        # lower triangle
        mask[rows-1-row, i] = switch
      end
      
      # middle section
      on = columns - offset * 2 - row * 2
      off = (columns - on) / 2
      line_map = Array.new(off, false) + Array.new(on, true) + Array.new(off, false)
      line_map.each_with_index do |switch, i|
        # middle upper
        mask[row + size, i] = switch
        # middle lower
        mask[rows - 1 - size - row, i] = switch
      end
    end
  end
  
  def rows
    size * 4
  end
  
  def columns
    (size - 1) * 6 + 5 + offset * 2
  end
  
  def offset
    size.even? ? 0 : 1
  end
end

__END__

1
XXX.XXX
X.....X
X.....X
XXX.XXX

2
XXXXX.XXXXX
XXXX...XXXX
...........
X.........X
X.........X
...........
XXXX...XXXX
XXXXX.XXXXX

3
XXXXXXXXX.XXXXXXXXX
XXXXXXXX...XXXXXXXX
XXXXXXX.....XXXXXXX
X.................X
XX...............XX
XXX.............XXX
XXX.............XXX
XX...............XX
X.................X
XXXXXXX.....XXXXXXX
XXXXXXXX...XXXXXXXX
XXXXXXXXX.XXXXXXXXX

4
XXXXXXXXXXX.XXXXXXXXXXX
XXXXXXXXXX...XXXXXXXXXX
XXXXXXXXX.....XXXXXXXXX
XXXXXXXX.......XXXXXXXX
.......................
X.....................X
XX...................XX
XXX.................XXX
XXX.................XXX
XX...................XX
X.....................X
.......................
XXXXXXXX.......XXXXXXXX
XXXXXXXXX.....XXXXXXXXX
XXXXXXXXXX...XXXXXXXXXX
XXXXXXXXXXX.XXXXXXXXXXX

5
XXXXXXXXXXXXXXX.XXXXXXXXXXXXXXX
XXXXXXXXXXXXXX...XXXXXXXXXXXXXX
XXXXXXXXXXXXX.....XXXXXXXXXXXXX
XXXXXXXXXXXX.......XXXXXXXXXXXX
XXXXXXXXXXX.........XXXXXXXXXXX
X.............................X
XX...........................XX
XXX.........................XXX
XXXX.......................XXXX
XXXXX.....................XXXXX
XXXXX.....................XXXXX
XXXX.......................XXXX
XXX.........................XXX
XX...........................XX
X.............................X
XXXXXXXXXXX.........XXXXXXXXXXX
XXXXXXXXXXXX.......XXXXXXXXXXXX
XXXXXXXXXXXXX.....XXXXXXXXXXXXX
XXXXXXXXXXXXXX...XXXXXXXXXXXXXX
XXXXXXXXXXXXXXX.XXXXXXXXXXXXXXX
