
require 'io/console'

class Maze::Script

  attr_reader :seed

  attr_reader :options

  def initialize
    # default options
    @options = {
      type: :ortho, 
      grid_size: [4, 4],
      distances: false,
      ascii: true,
      cell_size: 1, 
      algorithm: :gt1,
      visualize: false,
      highlight: true,
      image: false,
      png_cell: 50,
      png_wall: 1,
      png_border: 0,
    }
  end

  def run args
    parser.parse!(args)

    initialize_random_seed
    
    # Run the algorithm on the grid
    if visualize?
      algorithm.on grid do |stat|
        # print the maze
        ascii = factory.create_ascii_formatter grid, 
          cell_size: options[:cell_size],
          highlighted_cells: stat.active
          
        puts ascii.render
        
        puts stat.info if stat.info
        sleep algorithm.speed
        sleep 1 if options[:visualize] == :runsegment && stat.segment
  
        # wait for keystroke ?
        if (options[:visualize] == :segment && stat.segment || options[:visualize] == :step)
          break if read_char == "\e"
        end
      end
    else
      algorithm.on grid
    end
    
    # Calculate the distances from a given start cell
    if distances?
      distances = grid[*origin].distances
    end

    # And the solution to a given end cell
    if solution?
      distances = distances.path_to grid[*goal]
      path_length = distances[grid[*goal]]
      highlighted_cells = distances.cells
      content_color = Hash.new(:magenta)
      content_color[grid[*origin]] = :red
      content_color[grid[*goal]] = :red
    end
    
    if longest?
      new_start, distance = distances.max
      new_distances = new_start.distances
      new_goal, distance = new_distances.max
      distances = new_distances.path_to new_goal
      path_length = distance
      highlighted_cells = distances.cells
      content_color = Hash.new(:magenta)
      content_color[new_start] = :red
      content_color[new_goal] = :red
    end

    # Render the maze, set defaults for missing options
    if ascii?
      ascii = factory.create_ascii_formatter grid, 
        cell_size: options[:cell_size], 
        distances: distances || nil,
        highlighted_cells: highlighted_cells || [],
        content_color: content_color || :blue
      puts ascii.render
    end
    
    puts algorithm.status
    puts "Random seed: #{seed}"
    puts "Path length: #{path_length}" if path_length

    if image?
      image = png.render grid
      image.save "maze.png"
      puts "Maze 'maze.png' saved."
    end
  end
  
  
  def parser
    OptionParser.new do |o|
      o.banner = "\nMaze generator\n\nUsage: #{File.basename $0} [options]\n"
      o.separator "\nGrid options:"

      o.on('-t', '--type TYPE', Maze::Factory.types, 'The type of the maze.', "One of #{Maze::Factory.types.join(', ')}") do |type|
        options[:type] = type
      end
      o.on('-g', '--grid-size ROWS[,COLUMNS]', Array, 'The number of rows and columns of the grid') do |v|
        options[:grid_size] = v.first(2).map(&:to_i)
        options[:grid_size][1] ||= options[:grid_size][0]
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
        options[:distances] = (distances || [0,0]).map(&:to_i)
      end
      o.on('--[no-]solution [ROW,COLUMN]', Array, 'Find the shortest path to cell(ROW/COLUMN).') do |solution|
        options[:solution] = (solution || [-1,-1]).map(&:to_i)
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

      o.separator "\nPNG Options:"
  
      o.on('--[no-]image', 'Render the maze as PNG image.') do |image|
        options[:image] = image
      end
      o.on('--cell-width PIXEL', Integer, 'The width of a cell.') do |px|
        options[:png_cell] = px
      end
      o.on('--wall PIXEL', Integer, 'The width of the walls.') do |px|
        options[:png_wall] = px
      end
      
      # TODO: option for wall color
      
      o.on('--border PIXEL', Integer, 'The width of the border around the maze.') do |px|
        options[:png_border] = px
      end  
  
      o.separator ""
    end
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
    !!@options[:distances] || !!@options[:solution] || !!options[:longest]
  end
  
  def solution?
    !!@options[:solution]
  end
  
  def longest?
    !!@options[:longest]
  end
  
  def origin
    @options[:distances] || [0,0]
  end
  
  def goal
    @options[:solution].first == -1 ? [grid.rows - 1,0] : @options[:solution]
  end
  
  def factory
    @factory ||= Maze::Factory.new options[:type]
  end
  
  def grid
    @grid ||= factory.create_grid *options[:grid_size]
  end
  
  def algorithm
    @algorithm ||= factory.create_algorithm options[:algorithm]
  end
  
  def ascii
    @ascii ||= factory.create_ascii_formatter cell_size: options[:cell_size]
  end
  
  def png
    @png ||= factory.create_png_formatter cell_size: options[:png_cell], border: options[:png_border], line_width: options[:png_wall]
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