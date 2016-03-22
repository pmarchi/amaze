
class Maze::Grid::Delta < Maze::Grid

  def prepare_grid
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        # Use the square cells, since the neighbors are the same
        Maze::Cell::Square.new row, column
      end
    end
  end
  
  def configure_cell
    each_cell do |cell|
      row, column = cell.row, cell.column
      
      cell.east = self[row, column+1]
      cell.west = self[row, column-1]
      
      if (row+column).even?
        cell.north = self[row-1, column]
      else
        cell.south = self[row+1, column]
      end
    end
  end
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
