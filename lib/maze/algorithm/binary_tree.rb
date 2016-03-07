
class Maze::Algorithm::BinaryTree
  def self.on grid
    grid.each_cell do |cell|
      links = [cell.north, cell.east].compact
      next if links.empty?
      cell.link links[rand(links.size)]
    end
    grid
  end
end