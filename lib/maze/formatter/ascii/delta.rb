
class Maze::Formatter::ASCII::Delta < Maze::Formatter::ASCII

  def draw_cell cell
    x0, y0 = coord cell
    
    # reverse triangle
    if (cell.column + cell.row).even?
      # corner
      char[y0][x0] = corner.color(grid_color)
      char[y0][x0+(cell_size+1)*2] = corner.color(grid_color)
      char[y0+cell_size+1][x0+cell_size+1] = corner.color(grid_color)
      
      0.upto(cell_size*2) do |i|
        # north
        char[y0][x0+1+i] = h.color(grid_color)
      end unless cell.linked_to?(:north)
      1.upto(cell_size) do |i|
        # west
        char[y0+i][x0+i] = rw.color(grid_color) unless cell.linked_to?(:west)
        # east
        char[y0+i][x0+(cell_size+1)*2-i] = re.color(grid_color) unless cell.linked_to?(:east)
      end
      
    # normal triangle
    else
      # corner
      char[y0+cell_size+1][x0] = corner.color(grid_color)
      char[y0+cell_size+1][x0+(cell_size+1)*2] = corner.color(grid_color)
      char[y0][x0+cell_size+1] = corner.color(grid_color)
      
      0.upto(cell_size*2) do |i|
        # south
        char[y0+cell_size+1][x0+1+i] = h.color(grid_color)
      end unless cell.linked_to?(:south)
      1.upto(cell_size) do |i|
        # west
        char[y0+i][x0+cell_size+1-i] = nw.color(grid_color) unless cell.linked_to?(:west)
        # east
        char[y0+i][x0+cell_size+1+i] = ne.color(grid_color) unless cell.linked_to?(:east)
      end
      
    end
  end

  def draw_content cell
    x0, y0 = coord cell
    
    if cell_size == 1
      my = y0 + 1
      mx = x0 + 2
      w = 1
    else
      mx = x0 + cell_size / 2 + 1
      w = (cell_size+1) / 2 * 2 + 1
      if (cell.column+cell.row).even?
        my = y0 + cell_size / 2
      else
        my = y0 + (cell_size+3) / 2
      end
    end
    
    distance(cell).center(w).chars.each_with_index do |c,i|
      char[my][mx+i] = c.color(*distance_color(cell))
    end
  end
  
  def draw_path cell
    x0, y0 = coord cell
    
    mx = x0 + cell_size + 1
    my = y0 + (cell_size + 1) / 2
    
    # center
    char[my][mx] = center.color(path_color)
    1.upto(cell_size) do |i|
      # east-west
      char[my][mx+i] = h.color(path_color) if path?(:east, cell)
      # north-south
      char[my+i][mx] = v.color(path_color) if path?(:south, cell)
    end
  end
  
  def coord cell
    [xpos(cell.column), ypos(cell.row)]
  end
  
  def xpos column
    (cell_size + 1) * column
  end
  
  def ypos row
    (cell_size + 1) * row
  end
  
  def char_array_width
    xpos(grid.columns + 1) + 1
  end
  
  def char_array_height
    ypos(grid.rows) + 1
  end
  
  def h
    '-'
  end
  
  def v
    '|'
  end
  
  def rw
    '\\'
  end
  
  def re
    '/'
  end
  
  def corner
    '∙'
  end
  
  alias_method :center, :corner
  alias_method :nw, :re
  alias_method :ne, :rw
  
end

__END__

    mx    w    yr    yn
c1  2     1    1     1

c2  2     3    1     2       cell_size / 2        cell_size + 3 / 2
c3  2     5    1     3
c4  3     5    2     3
c5  3     7    2     4
c6  4     7    3     4        cell_size / 2 + 1
c7  4     9    3     5     cell_size+1/2 * 2 + 1

∙---∙---∙
 \...\ / \
  ∙ . ∙---∙
 / \./ \ /
∙---∙---∙
 \ / \ / \
  ∙---∙---∙

∙-----∙-----∙
 \ ....\ * / \
  \   . \ /   \
   ∙  .  ∙-----∙
  /.... / \   /
 / .   /   \ /
∙  .  ∙-----∙
 \ . / \   / \
  \ /   \ /   \
   ∙-----∙-----∙

∙-------∙-------∙
 \       \     / \
  \ ..... \   /   \
   \    .  \ /     \
    ∙   .   ∙-------∙
   / \  .  / \     / 
  /   \   /   \   /
 /     \ /     \ /
∙-------∙-------∙
 \     / \     / \
  \   /   \   /   \
   \ /     \ /     \
    ∙-------∙-------∙

∙---------∙---------∙
 \       / \       / \
  \  .      \     /   \
   \    ` .  \   /     \
    \ /       \ /       \
     ∙---------∙---------∙
    / \       / \       / 
   /   \     /   \     / 
  /     \   /     \   /
 /       \ /       \ /
∙---------∙---------∙
 \       / \       / \
  \     /   \     /   \
   \   /     \   /     \
    \ /       \ /       \
     ∙---------∙---------∙
