
require 'optparse'
require 'io/console'
require 'rainbow/ext/string'

class Maze::Script

  attr_reader :seed

  attr_reader :options

  def initialize
    # default options
    @options = {
      type: :ortho, 
      distances: false,
      ascii: true,
      algorithm: :gt1,
      visualize: false,
      highlight: true,
      image: false,
    }
  end

  def parser
    OptionParser.new do |o|
      o.banner = "\nMaze generator\n\nUsage: #{File.basename $0} [options]\n"
      o.separator "\nGrid options:"

      o.on('-t', '--type TYPE', Maze::Factory.types, 'The type of the maze.', "One of #{Maze::Factory.types.join(', ')}") do |type|
        options[:type] = type
      end
      o.on('-g', '--grid-size ROWS[,COLUMNS]', Array, 'The number of rows and columns of the grid') do |v|
        options[:grid_size] = Array(v).map(&:to_i)
      end
      o.on('-m', '--mask MASKFILE', String, 'MASKFILE is either a ASCII file or a PNG file.') do |mask|
        options[:mask] = mask
      end
  
      o.separator "\nAlgorithm options:"

      o.on('-a', '--algorithm ALGORITHM', Maze::Factory.algorithms, 'The algorithm to generate the maze.', "One of #{Maze::Factory.algorithms.join(', ')}") do |algorithm|
        options[:algorithm] = algorithm
      end
      o.on('-S', '--seed SEED', Integer, 'Set random seed') do |seed|
        options[:seed] = seed
      end
      visualization_modes = [:run, :runsegment, :segment, :step]
      o.on('-v', '--visualize [MODE]', visualization_modes, 'Visualize the progress of the algorithm', "One of #{visualization_modes.join(', ')}") do |mode|
        options[:visualize] = mode || :run
      end

      o.separator "\nSolution options:"

      o.on('--[no-]distances [ROW,COLUMN]', Array, 'Calculate the distances from cell(ROW/COLUMN) to all other cells of the grid.') do |distances|
        options[:distances] = distances ? distances.map(&:to_i) : :auto
      end
      o.on('--[no-]solution [ROW,COLUMN]', Array, 'Find the shortest path to cell(ROW/COLUMN).') do |solution|
        options[:solution] = solution ? solution.map(&:to_i) : :auto
      end
      o.on('--[no-]longest', 'Find the longest path of the maze.') do |longest|
        options[:longest] = longest
      end
  
      o.separator "\nASCII Options:"
  
      o.on('--[no-]ascii', 'Render the maze with ASCII on the terminal.') do |ascii|
        options[:ascii] = ascii
      end
      o.on('-c', '--cell-size SIZE', Integer, 'The size of the cell') do |cell_size|
        options[:cell_size] = cell_size
      end
      o.on('--grid-color NAME', Rainbow::X11ColorNames::NAMES.keys, 'The color of the grid.') do |color|
        options[:ascii_grid_color] = color
      end
      o.on('--path-color NAME', Rainbow::X11ColorNames::NAMES.keys, 'The color of the path, when drawing the solution or longest path.') do |color|
        options[:ascii_path_color] = color
      end
      o.on('--distances-color NAME', Rainbow::X11ColorNames::NAMES.keys, 'The color of the distances.') do |color|
        options[:ascii_distances_color] = color
      end
      o.on('--all-ascii-colors', 'Print all the supported ascii colors.') do
        puts Rainbow::X11ColorNames::NAMES.keys.map {|n| n.to_s.color(n) }.join(' ')
        exit 0
      end

      o.separator "\nPNG Options:"
  
      o.on('--[no-]image', 'Render the maze as PNG image.') do |image|
        options[:image] = image
      end
      o.on('--cell-width PIXEL', Integer, 'The width of a cell.') do |px|
        options[:png_cell] = px
      end
      o.on('--border PIXEL', Integer, 'The width of the border around the maze.') do |px|
        options[:png_border] = px
      end
      o.on('--wall PIXEL', Integer, 'The width of the walls.') do |px|
        options[:png_wall] = px
      end
      o.on('--wall-color NAME', Maze::Formatter::PNG.colors, 'The color of the walls. Provide a HTML color name.') do |color|
        options[:png_wall_color] = color
      end
      o.on('--background-color NAME', Maze::Formatter::PNG.colors, 'The background color. Provide a HTML color name.') do |color|
        options[:png_background_color] = color
      end
      o.on('--gradient-map NAME', Maze::Factory.gradient_maps, 'The gradient map to use for the distances color.', "One of #{Maze::Factory.gradient_maps.join(', ')}") do |map|
        options[:gradient_map] = map
      end
      o.on('--all-png-colors', 'Print all the supported png colors.') do
        puts Maze::Formatter::PNG.colors.join(', ')
        exit 0
      end
  
      o.separator ""
    end
  end
  
  def run args
    parser.parse!(args)
    
    initialize_random_seed
    
    # Run the algorithm on the grid
    if visualize?
      algorithm.on grid do |stat|
        # print the maze
        ascii = factory.create_ascii_formatter grid,
          ascii_options(path_color: :blue, path_cells: stat.current)
          
        puts ascii.render
        
        puts stat.info if stat.info
        sleep algorithm.speed
        sleep 1 if options[:visualize] == :runsegment && stat.pause?
  
        # wait for keystroke ?
        if (options[:visualize] == :segment && stat.pause? || options[:visualize] == :step)
          case read_char
          when "\e"
            break
          when "r"
            options[:visualize] = :run
          end
        end
      end
    else
      algorithm.on grid
    end
    
    ascii_runtime_options = {}
    
    # Calculate the distances from a given start cell
    if distances?
      distances = start_cell.distances
      ascii_runtime_options[:distances] = distances
    end

    # And the solution to a given end cell
    if solution?
      distances = start_cell.distances.path_to finish_cell
      ascii_runtime_options[:path_cells] = distances.cells
      path_length = distances[finish_cell]
    end
    
    if longest?
      new_start, distance = start_cell.distances.max
      new_distances = new_start.distances
      new_finish, distance = new_distances.max
      distances = new_distances.path_to new_finish
      ascii_runtime_options[:path_cells] = distances.cells
      path_length = distance
    end

    # Render the maze, set defaults for missing options
    if ascii?
      ascii = factory.create_ascii_formatter grid, ascii_options(ascii_runtime_options)
      puts ascii.render
    end
    
    puts algorithm.status
    puts "Dead ends: #{grid.deadends.size} of #{grid.size} (#{(100.to_f / grid.size * grid.deadends.size).to_i}%)"
    puts "Path length: #{path_length}" if path_length
    puts "Random seed: #{seed}"

    if image?
      png = factory.create_png_formatter grid,
        png_options(distances: (distances || nil))

      png.render_background
      png.render
      png.image.save "maze.png"
      puts "Maze 'maze.png' saved."
    end
  end
    
  def ascii_options runtime_options={}
    { 
      cell_size: options[:cell_size] || 1,
      grid_color: options[:ascii_grid_color] || :white,
      path_color: options[:ascii_path_color] || :red,
      distances_color: options[:ascii_distances_color]
    }.merge runtime_options
  end
  
  def png_options runtime_options={}
    { 
      cell_size: options[:png_cell] || 10,
      background_color: options[:png_background_color] || :white,
      border: options[:png_border] || 0,
      line_width: options[:png_wall] || 1,
      line_color: options[:png_wall_color] || :black,
      gradient_map: factory.gradient_map(options[:gradient_map] || :warm),
    }.merge runtime_options
  end
  
  def ascii?
    @options[:ascii]
  end
  
  def image?
    @options[:image]
  end
  
  def visualize?
    @options[:ascii] && !!@options[:visualize]
  end
  
  def distances?
    !!@options[:distances]
  end
  
  def solution?
    !!@options[:solution]
  end
  
  def longest?
    !!@options[:longest]
  end
  
  def start_cell
    if !@options[:distances] || @options[:distances] == :auto
      column = grid.columns.times.find {|i| grid[0,i] }
      return grid[0,column] if column
      row = grid.rows.times.find {|i| grid[i,0] }
      return grid[row,0]
    else
      grid[*@options[:distances]]
    end
  end
  
  def finish_cell
    if !@options[:solution] || @options[:solution] == :auto
      column = grid.columns.times.find {|i| grid[grid.rows-1,grid.columns-1-i] }
      return grid[grid.rows-1,grid.columns-1-column] if column
      row = grid.rows.times.find {|i| grid[grid.rows-1-i,grid.columns-1] }
      return grid[grid.rows-1-row,grid.columns-1]
    else
      grid[*@options[:solution]]
    end
  end
  
  def factory
    @factory ||= Maze::Factory.new options[:type]
  end
  
  def grid
    @grid ||= if options[:mask]
      factory.create_masked_grid options[:mask]
    else
      factory.create_grid *grid_size
    end
  end
  
  def grid_size
    # double the columns for delta grids if not specified
    if options[:grid_size]
      size = options[:grid_size].first(2).map(&:to_i)
      size[1] ||= (options[:type] == :delta ? options[:grid_size][0] * 2 : options[:grid_size][0])
    else
      size = [4, options[:type] == :delta ? 8 : 4]
    end
    size
  end
  
  def algorithm
    @algorithm ||= factory.create_algorithm options[:algorithm]
  end
  
  def initialize_random_seed
    if options[:seed]
      @seed = options[:seed]
    else
      srand
      @seed = srand
    end
    srand @seed
  end
  
  # Reads keypresses from the user including 2 and 3 escape character sequences.
  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!
    return input
  end
end