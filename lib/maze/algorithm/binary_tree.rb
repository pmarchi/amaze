
class Maze::Algorithm::BinaryTree < Maze::Algorithm

  def work grid
    grid.each_cell do |cell|
      links = [cell.north, cell.east].compact
      next if links.empty?
      cell.link links[rand(links.size)]
      yield cell if block_given?
    end
  end
  
  def status
    "Binary tree algorithm: #{duration}s"
  end
end