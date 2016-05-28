
class Amaze::Algorithm::BinaryTree < Amaze::Algorithm
  
  register :bt

  def work grid
    count = 0 # visualize
    grid.each_cell do |cell|
      links = [cell.north, cell.east].compact
      cell.link links[rand(links.size)] unless links.empty?

      yield Stat.new(                                # visualize
        current: [cell],                             #
        info: "Cell: #{count += 1}") if block_given? #
    end
    grid
  end
  
  def status
    "Binary tree algorithm: #{duration}s"
  end
end