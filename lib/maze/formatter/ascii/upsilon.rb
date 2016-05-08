
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
    x0, x1, x2, x3, y0, y1, y2, y3 = coord cell
    
    y = y1 + (y2 - y1) / 2
    distance(cell).center(cell_size * 3).chars.each_with_index do |c,i|
      char[y][x1+1+i] = c.color(*distance_color(cell))
    end
  end

  def draw_path cell
    x0, x1, x2, x3, y0, y1, y2, y3 = coord cell
    
    # middle of cell
    mx0 = (x1 + x2) / 2
    my0 = (y1 + y2) / 2
    
    # delta to middle of neighbor cell
    dx = cell_size * 4 + 2
    dy = cell_size * 2 + 2
    
    # north-south
    1.upto(dy-1) do |i|
      char[my0+i][mx0] = v.color(path_color)
    end if path?(:south, cell)
    # west-east
    1.upto(dx-1) do |i|
      char[my0][mx0+i] = h.color(path_color)
    end if path?(:east, cell)
    
    if (cell.column+cell.row).even?
      # northwest-southeast
      if path?(:southeast, cell)
        mx1 = mx0 + dx / 2
        my1 = my0 + dy / 2

        char[my1][mx1] = center.color(path_color)
        1.upto(cell_size) do |i|
          char[my0+i][mx0+i*2-1] = pnwse1.color(path_color)
          char[my0+i][mx0+i*2] = pnwse2.color(path_color)
          char[my1+i][mx1+i*2-1] = pnwse1.color(path_color)
          char[my1+i][mx1+i*2] = pnwse2.color(path_color)
        end
      end
      # northeast-southwest
      if path?(:southwest, cell)
        mx1 = mx0 - dx / 2
        my1 = my0 + dy / 2

        char[my1][mx1] = center.color(path_color)
        1.upto(cell_size) do |i|
          char[my0+i][mx0-i*2+1] = pswne1.color(path_color)
          char[my0+i][mx0-i*2] = pswne2.color(path_color)
          char[my1+i][mx1-i*2+1] = pswne1.color(path_color)
          char[my1+i][mx1-i*2] = pswne2.color(path_color)
        end
      end
    end

    # center
    char[my0][mx0] = center.color(path_color)
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
  
  def pnwse1
    '`'
  end
  
  def pnwse2
    '.'
  end
  
  def pswne1
    '´'
  end
  
  alias_method :pswne2, :pnwse2

  def center
    '∙'
  end
    
  def corner
    '+'
  end
end

__END__

     x           y
c1   0  6  12    4   8  12      4  4  2  
c2   0 10  20    6  12  18      8  6  4
c3   0 14  28    8  16  24      12 8  6

  +---+       +---+       +---+      
 /     \     /     \     /     \     
+       +---+       +---+       +---+
|   ∙-----∙ |   ∙   |   |       |   |
+    `. +---+ .´|   +---+       +---+
 \     ∙     ∙  |  /     \     /     \
  +---+ `. .´ + | +       +---+       +
  |   |   ∙   | ∙ |       |   |       |
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
|     ∙---------∙   |     ∙      |      |            |      |
|      `.           |   .´|      |      |            |      |
+        `.  +------+ .´  |      +------+            +------+
 \         ∙         ∙    |     /        \          /        \ 
  \         `.     .´     |    /          \        /          \
   +------+   `. .´    +  |   +            +------+            +
   |      |     ∙      |  ∙   |            |      |            |
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
|                           |                 |         |                 |         |
|        ∙-------------∙    |        ∙        |         |                 |         |
|         `.                |      .´|        |         |                 |         |
+           `.    +---------+    .´  |        +---------+                 +---------+
 \            `.               .´    |       /           \               /           \ 
  \             ∙             ∙      |      /             \             /             \ 
   \             `.         .´       |     /               \           /               \
    +---------+    `.     .´    +    |    +                 +---------+                 +
    |         |      `. .´      |    |    |                 |         |
    |         |        ∙        |    ∙    |                 |         |
    |         |                 |         |                 |         |
    +---------+                 +---------+                 +---------+      
   /           \               /           \               /           \     
  /             \             /             \             /             \     
 /               \           /               \           /               \    
+                 +---------+                 +---------+                 +---------+
