
class Maze::Formatter::ASCII::Delta < Maze::Formatter::ASCII

  # FIXME render does not work for masked grids

  def draw_cell cell
    x0, y0 = coord cell
    # reverse triangle
    if (cell.column + cell.row).even?
      1.upto(cell_size*2) do |i|
        # base
        char[y0][x0+i] = h
        char[y0][x0] = h unless cell.north
        char[y0][x0+cell_size*2+1] = h unless cell.north
      end
      0.upto(cell_size) do |i|
        # east
        char[y0+i+1][x0+cell_size*2+1-i] = re
        # west
        char[y0+i+1][x0+i] = rw
      end

    # normal triangle
    else
      1.upto(cell_size*2) do |i|
        # base
        char[y0+cell_size+1][x0+i] = h
      end
      0.upto(cell_size) do |i|
        # east
        char[y0+i+1][x0+cell_size+1+i] = ne
        # west
        char[y0+i+1][x0+cell_size-i] = nw
        
      end
    end
  end
  
  def draw_content cell
  end
  
  def draw_path cell
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
\    /\    /\    /
 \  /  \  /  \  /
  \/____\/____\/
  /\    /\    /\
 /  \  /  \  /  \
/____\/____\/____\
\    /\    /\    /
 \  /  \  /  \  /
  \/____\/____\/
  /\    /\    /\
 /  \  /  \  /  \
/____\/____\/____\
\    /\    /\    /
 \  /  \  /  \  /
  \/____\/____\/

 ______  ______  ______ 
\      /\      /\      /
 \ *  /  \    /  \    /
  \  / *  \  /    \  /
   \/______\/______\/
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
  \  *   /    \      /    \      /
   \    /  *   \    /      \    /
    \  /        \  /        \  /
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
