
class Maze::Algorithm::BinaryTree < Maze::Algorithm

  def work grid
    stat.segment = false
    
    grid.each_cell do |cell|
      links = [cell.north, cell.east].compact
      cell.link links[rand(links.size)] unless links.empty?

      stat.active = [cell]
      yield stat if block_given?
    end
    grid
  end
  
  def status
    "Binary tree algorithm: #{duration}s"
  end
end