
require 'optparse'

class Amaze::Script::Options

  def opts
    @opts ||= OptionParser.new
  end
  
  def parse! args
    parser
    opts.parse! args
  end

  def options
    @options ||= {
      type: :ortho,
      grid_size: [4],
      distances: false,
      formats: [:ascii],
    }
  end
  
  def parser
    opts.banner = "\nMaze generator\n\nUsage: #{File.basename $0} [options]\n"
    opts.separator "\nGrid options:"

    opts.on('-t', '--type TYPE', Amaze::Grid.all, 'The type of the maze.', "One of #{Amaze::Grid.all.join(', ')}") do |type|
      options[:type] = type
    end
    opts.on('-g', '--grid-size ROWS[,COLUMNS]', Array, 'The size of the grid.') do |v|
      options[:grid_size] = Array(v).map(&:to_i)
    end
    opts.on('-m', '--mask MASKFILE', String, 'MASKFILE is either a ASCII file or a PNG file.') do |mask|
      options[:mask] = mask
    end
    opts.on('-s', '--shape SHAPE', Amaze::Shape.all, "One of #{Amaze::Shape.all.join(', ')}.", "Shapes won't work on polar mazes.") do |shape|
      options[:shape] = shape
    end

    opts.separator "\nSolution options:"

    opts.on('--[no-]distances [ROW,COLUMN]', Array, 'Calculate the distances from cell(ROW/COLUMN) to all other cells of the grid.') do |distances|
      options[:distances] = distances ? distances.map(&:to_i) : :auto
    end
    opts.on('--[no-]solution [ROW,COLUMN]', Array, 'Find the shortest path to cell(ROW/COLUMN).') do |solution|
      options[:solution] = solution ? solution.map(&:to_i) : :auto
    end
    opts.on('--[no-]longest', 'Find the longest path of the maze.') do |longest|
      options[:longest] = longest
    end

    opts.separator "\nRender Options:"

    opts.on('-f', '--format [FORMAT,...]', Array, 'Render the maze on the given formats.') do |formats|
      options[:formats] = formats.map(&:to_sym)
    end

    opts.separator ""
  end
end