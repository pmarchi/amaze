
require 'io/console'

class Amaze::Script
  autoload :Options, 'amaze/script/options'
  autoload :AsciiOptions, 'amaze/script/ascii_options'
  autoload :ImageOptions, 'amaze/script/image_options'

  attr_reader :seed
  
  def parser
    @parser ||= Amaze::Script::Options.new.tap do |p|
      p.extend Amaze::Script::AsciiOptions
      p.extend Amaze::Script::ImageOptions
    end
  end
  
  def options
    parser.options
  end
  
  def ascii_options runtime_options={}
    parser.ascii_options.merge runtime_options
  end
    
  def image_options runtime_options={}
    parser.image_options.merge runtime_options
  end

  def run args
    parser.parse!(args)
    
    initialize_random_seed
    
    # Run the algorithm on the grid
    if visualize?
      algorithm.on grid do |stat|
        # print the maze
        ascii = Amaze::Formatter::ASCII.create options[:type], grid,
          ascii_options(path_color: :blue, path_cells: stat.current)
          
        puts ascii.render
        
        puts stat.info if stat.info
        sleep algorithm.speed
        sleep 1 if options[:visualize] == :autopause && stat.pause?
  
        # wait for keystroke ?
        if (options[:visualize] == :pause && stat.pause? || options[:visualize] == :step)
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
    image_runtime_options = {}
    
    # Calculate the distances from a given start cell
    if distances?
      distances = start_cell.distances
      ascii_runtime_options[:distances] = distances
      image_runtime_options[:distances] = distances
    end

    # And the solution to a given end cell
    if solution?
      distances = start_cell.distances.path_to finish_cell
      ascii_runtime_options[:path_cells] = distances.cells
      image_runtime_options[:path_cells] = distances.cells
      image_runtime_options[:path_start] = start_cell
      image_runtime_options[:path_finish] = finish_cell
      path_length = distances[finish_cell]
    end
    
    if longest?
      new_start, _ = start_cell.distances.max
      new_distances = new_start.distances
      new_finish, distance = new_distances.max
      distances = new_distances.path_to new_finish
      image_runtime_options[:distances] = new_distances if distances?
      ascii_runtime_options[:path_cells] = distances.cells
      image_runtime_options[:path_cells] = distances.cells
      image_runtime_options[:path_start] = new_start
      image_runtime_options[:path_finish] = new_finish
      path_length = distance
    end

    # Render the maze, set defaults for missing options
    if ascii?
      ascii = Amaze::Formatter::ASCII.create options[:type], grid, ascii_options(ascii_runtime_options)
      puts ascii.render
    end
    
    puts algorithm.status
    puts "Dead ends: #{grid.deadends.size} of #{grid.size} (#{(100.to_f / grid.size * grid.deadends.size).to_i}%)"
    puts "Path length: #{path_length}" if path_length
    puts "Random seed: #{seed}"

    if image?
      image = Amaze::Formatter::Image.create options[:type], grid,
        image_options(image_runtime_options)
      image.render
      
      # TODO: write multiple images with solution and distances
      #       or a psd file with layers
      
      image.write "maze.png"
      puts "Maze 'maze.png' saved."
    end
  end
    
  def ascii?
    options[:formats].include? :ascii
  end
  
  def image?
    options[:formats].include? :image
  end
  
  def visualize?
    ascii? && !!options[:visualize]
  end
  
  def distances?
    !!options[:distances]
  end
  
  def solution?
    !!options[:solution]
  end
  
  def longest?
    !!options[:longest]
  end
  
  # TODO: specify a start cell should also work for polar grids
  
  def start_cell
    if options[:type] == :polar
      grid[grid.rows-1, 0]
    else
      if !options[:distances] || options[:distances] == :auto
        column = grid.columns.times.find {|i| grid[0,i] }
        return grid[0,column] if column
        row = grid.rows.times.find {|i| grid[i,0] }
        return grid[row,0]
      else
        grid[*options[:distances]]
      end
    end
  end
  
  # TODO: specify a finish cell should also work for polar grids
  
  def finish_cell
    if options[:type] == :polar
      row = grid.rows-1
      columns = grid.columns row
      grid[row, columns.size / 2]
    else
      if !options[:solution] || options[:solution] == :auto
        column = grid.columns.times.find {|i| grid[grid.rows-1,grid.columns-1-i] }
        return grid[grid.rows-1,grid.columns-1-column] if column
        row = grid.rows.times.find {|i| grid[grid.rows-1-i,grid.columns-1] }
        return grid[grid.rows-1-row,grid.columns-1]
      else
        grid[*options[:solution]]
      end
    end
  end
  
  def grid
    @grid ||= Amaze::Grid.create options[:type], *grid_args
  end
  
  def grid_args
    if options[:mask] || options[:shape]
      Amaze::Grid.registred[options[:type]].prepend Amaze::MaskedGrid
      if options[:mask]
        Amaze::Mask.from_file options[:mask]
      else
        Amaze::Mask.from_string(Amaze::Shape.create(options[:shape], grid_size.first).to_s)
      end
    else
      grid_size
    end
  end
  
  def grid_size
    # double the columns for delta grids if not specified
    size = options[:grid_size].first(2).map(&:to_i)
    size[1] ||= (options[:grid_size][0] * (options[:type] == :delta ? 2 : 1))
    size = size.first if options[:type] == :polar
    size
  end
  
  def algorithm
    @algorithm ||= Amaze::Algorithm.create options[:algorithm]
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
    input
  end
end