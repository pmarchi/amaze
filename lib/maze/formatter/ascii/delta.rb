
class Maze::Formatter::ASCII::Delta < Maze::Formatter::ASCII

  def draw_cell cell
    x0, y0 = coord cell
    # reverse triangle
    if (cell.column + cell.row).even?
      unless cell.north
        # base top row
        char[y0][x0] = h
        char[y0][x0+cell_size*2+1] = h
      end
      1.upto(cell_size*2) do |i|
        # base
        char[y0][x0+i] = h unless cell.linked? cell.north
      end
      0.upto(cell_size) do |i|
        # east
        char[y0+i+1][x0+cell_size*2+1-i] = re unless cell.linked? cell.east
        # west
        char[y0+i+1][x0+i] = rw unless cell.linked? cell.west
      end

    # normal triangle
    else
      1.upto(cell_size*2) do |i|
        # base
        char[y0+cell_size+1][x0+i] = h unless cell.linked? cell.south
      end
      0.upto(cell_size) do |i|
        # east
        char[y0+i+1][x0+cell_size+1+i] = ne unless cell.linked? cell.east
        # west
        char[y0+i+1][x0+cell_size-i] = nw unless cell.linked? cell.west
        
      end
    end
  end
  
  def draw_content cell
  end
  
  def draw_path cell
    x0, y0 = coord cell
    
    # FIXME: postition of center differs for odd cells
    char[y0+cell_size][x0+cell_size] = c.color(content_color_of cell)
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
    xpos(grid.columns + 1)
  end
  
  def char_array_height
    ypos(grid.rows) + 1
  end
  
  def h
    '_'
  end
  
  def rw
    '\\'
  end
  
  def re
    '/'
  end
  
  def c
    '.'
  end
  
  alias_method :nw, :re
  alias_method :ne, :rw
  
end

__END__

 __  __
\* /\  /\
 \/__\/__\
 /\  /\  /
/__\/__\/
\  /\  /\
 \/__\/__\
 /\  /\  /
/__\/__\/


 ____  ____  ____ 
\ .   \    /\    /
 \.... \  /  \  /
  \  .  \/____\/
  /  .  /\    /\
 /.... /. \. /  \
/ .   /____\/____\
\ .  /\    /\    /
 \  /  \  /  \  /
  \/____\/____\/
  /\    /\    /\
 /  \  /  \  /  \
/____\/____\/____\
\    /\    /\    /
 \  /  \  /  \  /
  \/____\/____\/

 ______  ______  ______ 
\       \      /\      /
 \ .     \    /  \    /
  \  ` .  \  /    \  /
   \ ______\/______\/
   /\      /\      /\
  /  \    /  \    /  \
 /    \  /    \  /    \
/______\/______\/______\
\      /\      /\      /
 \    /  \    /  \    /
  \  /    \  /    \  /
   \/______\/______\/
   /\      /\      /\
  /  \    /  \    /  \
 /    \  /    \  /    \
/______\/______\/______\
\      /\      /\      /
 \    /  \    /  \    /
  \  /    \  /    \  /
   \/______\/______\/


 __________  __________  __________
\          /\          /\          /
 \        /  \        /  \        /
  \  .        \      /    \      /
   \    `  .   \    /      \    /
    \           \  /        \  /
     \/__________\/__________\/
     /\          /\          /\     
    /  \        /  \        /  \    
   /    \      /    \      /    \   
  /      \    /      \    /      \  
 /        \  /        \  /        \ 
/__________\/__________\/__________\
\          /\          /\          /
 \        /  \        /  \        /
  \      /    \      /    \      /
   \    /      \    /      \    /
    \  /        \  /        \  /
     \/__________\/__________\/
     /\          /\          /\     
    /  \        /  \        /  \    
   /    \      /    \      /    \   
  /      \    /      \    /      \  
 /        \  /        \  /        \ 
/__________\/__________\/__________\




∙---∙---∙
 \...\ / \
  ∙---∙---∙
 / \ / \ /
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
 \     / \     / \
  \ ..... \   /   \
   \ /     \ /     \
    ∙-------∙-------∙
   / \     / \     / 
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
