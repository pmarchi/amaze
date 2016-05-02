
class Maze::Formatter::ASCII::Delta < Maze::Formatter::ASCII

  def draw_cell cell
    x0, y0 = coord cell
    
    # reverse triangle
    if (cell.column + cell.row).even?
      # corner
      char[y0][x0] = corner
      char[y0][x0+(cell_size+1)*2] = corner
      char[y0+cell_size+1][x0+cell_size+1] = corner
      
      0.upto(cell_size*2) do |i|
        # north
        char[y0][x0+1+i] = h
      end unless cell.linked_to?(:north)
      1.upto(cell_size) do |i|
        # west
        char[y0+i][x0+i] = rw unless cell.linked_to?(:west)
        # east
        char[y0+i][x0+(cell_size+1)*2-i] = re unless cell.linked_to?(:east)
      end
      
    # normal triangle
    else
      # corner
      char[y0+cell_size+1][x0] = corner
      char[y0+cell_size+1][x0+(cell_size+1)*2] = corner
      char[y0][x0+cell_size+1] = corner
      
      0.upto(cell_size*2) do |i|
        # south
        char[y0+cell_size+1][x0+1+i] = h
      end unless cell.linked_to?(:south)
      1.upto(cell_size) do |i|
        # west
        char[y0+i][x0+cell_size+1-i] = nw unless cell.linked_to?(:west)
        # east
        char[y0+i][x0+cell_size+1+i] = ne unless cell.linked_to?(:east)
      end
      
    end
  end

  def draw_content cell
    # TODO: implement draw content for delta grids
  end
  
  def draw_path cell
    x0, y0 = coord cell
    
    mx = x0 + cell_size + 1
    my = y0 + (cell_size + 1) / 2
    
    # center
    char[my][mx] = center.color(content_color_of cell)
    1.upto(cell_size) do |i|
      # east-west
      char[my][mx+i] = h.color(content_color_of cell) if path?(:east, cell)
      # north-south
      char[my+i][mx] = v.color(content_color_of cell) if path?(:south, cell)
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
