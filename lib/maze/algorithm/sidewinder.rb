
class Maze::Algorithm::Sidewinder < Maze::Algorithm

  def work grid
    run = []
    grid.each_cell do |cell|
      run << cell
      
      dig_north = cell.north && (!cell.east || rand(2) == 0)
      
      stat.segment = dig_north
      stat.active = run
      yield stat if block_given?
      
      # dig north if there is a cell north AND
      #   you can't dig east OR
      #   you choose randomly
      if dig_north
        # dig north (choose one cell of the run set)
        run.sample.tap {|c| c.link c.north }
      
      # dig east if there is a cell east
      elsif cell.east
        # dig east (keep run set)
        cell.link cell.east
        next
      end

      run.clear
    end
    grid
  end
  
  def speed
    0.1
  end
  
  def status
    "Sidewinder algorithm: #{duration}s"
  end
end