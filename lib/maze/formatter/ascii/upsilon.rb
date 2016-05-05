
class Maze::Formatter::ASCII::Upsilon < Maze::Formatter::ASCII
  
  def draw_cell cell
    x0, x1, x2, x3, y0, y1, y2, y3 = coord cell
    
    if (cell.row+cell.column).even?
      # draw octo cell
      # corners
      char[y0][x1] = corner
      char[y0][x2] = corner
      char[y1][x0] = corner
      char[y1][x3] = corner
      char[y2][x0] = corner
      char[y2][x3] = corner
      char[y3][x1] = corner
      char[y3][x2] = corner
      1.upto(cell_size) do |i|
        # northeast
        char[y0+i][x2+i] = ne unless cell.linked_to?(:northeast)
        # southeast
        char[y2+i][x3-i] = se unless cell.linked_to?(:southeast)
        # southwest
        char[y2+i][x0+i] = sw unless cell.linked_to?(:southwest)
        # northwest
        char[y0+i][x1-i] = nw unless cell.linked_to?(:northwest)
        # east
        char[y1+i][x3] = v unless cell.linked_to?(:east)
        # west
        char[y1+i][x0] = v unless cell.linked_to?(:west)
      end
      1.upto(cell_size*3) do |i|
        # north
        char[y0][x1+i] = h unless cell.linked_to?(:north)
        # south
        char[y3][x1+i] = h unless cell.linked_to?(:south)
      end
    else
      # draw square cell
      # corners
      char[y1][x1] = corner
      char[y1][x2] = corner
      char[y2][x1] = corner
      char[y2][x2] = corner
      1.upto(cell_size) do |i|
        # east
        char[y1+i][x2] = v unless cell.linked_to?(:east)
        # west
        char[y1+i][x1] = v unless cell.linked_to?(:west)
      end
      1.upto(cell_size*3) do |i|
        # north
        char[y1][x1+i] = h unless cell.linked_to?(:north)
        # south
        char[y2][x1+i] = h unless cell.linked_to?(:south)
      end
    end
  end

  def draw_content cell
    
    # TODO: render distances for upsilon mazes
    
  end

  def draw_path cell
    
    # TODO: render path for upsilon mazes
    
  end
  
  # left, right, top, bottom
  def coord cell
    x0 = x(cell.column)
    x1 = x0 + cell_size + 1
    x2 = x1 + cell_size * 3 + 1
    x3 = x2 + cell_size + 1
    y0 = y(cell.row)
    y1 = y0 + cell_size + 1
    y2 = y1 + cell_size + 1
    y3 = y2 + cell_size + 1
    [x0, x1, x2, x3, y0, y1, y2, y3]
  end
  
  def x column
    # x0 for octo cell
    (cell_size * 4 + 2) * column
  end
  
  def y row
    # y0 for octo cell
    (cell_size * 2 + 2) * row
  end
  
  def char_array_width
    x(grid.columns) + cell_size + 2
  end
  
  def char_array_height
    y(grid.rows) + cell_size + 2
  end
  
  def h
    '-'
  end
  
  def v
    '|'
  end
  
  def ne
    '\\'
  end
  
  def se
    '/'
  end

  alias_method :sw, :ne
  alias_method :nw, :se
  
  def center
    '∙'
  end
    
  def corner
    '+'
  end
end

__END__

     x           y
c1   0  6  12    4   8  12      cell_size * 2 + 2
c2   0 10  20    6  12  18
c3   0 14  28    8  16  24

  +---+       +---+       +---+      
 /     \     /     \     /     \     
+       +---+       +---+       +---+
|       |   |       |   |       |   |
+       +---+       +---+       +---+
 \     /     \     /     \     /     \
  +---+       +---+       +---+       +
  |   |       |   |       |   |       |
  +---+       +---+       +---+       +
 /     \     /     \     /     \     /
+       +---+       +---+       +---+
|       |   |       |   |       |   |
+       +---+       +---+       +---+
 \     /     \     /     \     /     \
  +---+       +---+       +---+       +
  |   |       |   |       |   |       |
  +---+       +---+       +---+       +
 /     \     /     \     /     \     /
+       +---+       +---+       +---+
|       |   |       |   |       |   |
+       +---+       +---+       +---+
 \     /     \     /     \     /     
  +---+       +---+       +---+      

   +------+            +------+            +------+      
  /        \          /        \          /        \     
 /          \        /          \        /          \     
+            +------+            +------+            +------+
|            |      |            |      |            |      |
|            |      |            |      |            |      |
+            +------+            +------+            +------+
 \          /        \          /        \          /        \ 
  \        /          \        /          \        /          \
   +------+            +------+            +------+            +
   |      |            |      |            |      |            |
   |      |            |      |            |      |            |
   +------+            +------+            +------+            +
  /        \          /        \          /        \          /
 /          \        /          \        /          \        /
+            +------+            +------+            +------+
|            |      |            |      |            |      |
|            |      |            |      |            |      |
+            +------+            +------+            +------+
 \          /        \          /        \          /        \ 
  \        /          \        /          \        /          \
   +------+            +------+            +------+            +
   |      |            |      |            |      |            |
   |      |            |      |            |      |            |
   +------+            +------+            +------+            +
  /        \          /        \          /        \          /
 /          \        /          \        /          \        /
+            +------+            +------+            +------+
|            |      |            |      |            |      |
|            |      |            |      |            |      |
+            +------+            +------+            +------+
 \          /        \          /        \          /
  \        /          \        /          \        /
   +------+            +------+            +------+

    +---------+                 +---------+                 +---------+      
   /           \               /           \               /           \     
  /             \             /             \             /             \     
 /               \           /               \           /               \    
+                 +---------+                 +---------+                 +---------+
|                 |         |                 |         |                 |         |
|                 |         |                 |         |                 |         |
|                 |         |                 |         |                 |         |
+                 +---------+                 +---------+                 +---------+
 \               /           \               /           \               /           \ 
  \             /             \             /             \             /             \ 
   \           /               \           /               \           /               \
    +---------+                 +---------+                 +---------+                 +
    |         |                 |         |                 |         |
    |         |                 |         |                 |         |
    |         |                 |         |                 |         |
    +---------+                 +---------+                 +---------+      
   /           \               /           \               /           \     
  /             \             /             \             /             \     
 /               \           /               \           /               \    
+                 +---------+                 +---------+                 +---------+
