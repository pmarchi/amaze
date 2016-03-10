
class Maze::Algorithm::Sidewinder < Maze::Algorithm

  def work grid
    run = []
    grid.each_cell do |cell|
      run << cell
      
      yield run

      # dig north if there is a cell north AND
      #   you can't dig east OR
      #   you choose randomly
      if cell.north && (!cell.east || rand(2) == 0)
        # dig north (choose one cell of the run set)
        run.sample.tap {|c| c.link c.north }
      
      # dig east if there is a cell east
      elsif cell.east
        # dig east (keep run set)
        cell.link cell.east
        next
      end

      run = []
    end
  end
  
  def speed
    0.1
  end
  
  def status
    "Sidewinder algorithm: #{duration}s"
  end
end