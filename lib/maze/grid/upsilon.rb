class Maze::Grid::Upsilon < Maze::Grid
  
  # TODO: implement a upsilon grid
  
  def prepare_grid
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|

        raise NotImplementedError

      end
    end
  end
  
  def configure_cell
  end
end

__END__

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

     
     
     
     
     
     
     
     
     
     
     
     
     
     