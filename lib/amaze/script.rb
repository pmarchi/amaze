
require 'io/console'

class Amaze::Script
  autoload :Options, 'amaze/script/options'
  autoload :AlgorithmOptions, 'amaze/script/algorithm_options'
  autoload :AsciiOptions, 'amaze/script/ascii_options'
  autoload :ImageOptions, 'amaze/script/image_options'

  attr_reader :seed
  
  def parser
    @parser ||= Amaze::Script::Options.new.tap do |p|
      p.extend Amaze::Script::AlgorithmOptions
      p.extend Amaze::Script::AsciiOptions
      p.extend Amaze::Script::ImageOptions
    end
  end
  
  def options
    @options ||= parser.options
  end
  
  def algorithm_options
    @algorithm_options ||= parser.algorithm_options
  end
  
  def ascii_options
    @ascii_options ||= parser.ascii_options
  end
    
  def image_options
    @image_options ||= parser.image_options
  end
  
  def run args
    parser.parse!(args)
    
    generate_maze

    compute_distances
    path_length = compute_path

    render_ascii if ascii?

    puts algorithm.status
    puts "Dead ends: #{grid.deadends.size} of #{grid.size} (#{(100.to_f / grid.size * grid.deadends.size).to_i}%)"
    puts "Path length: #{path_length}" if path_length
    puts "Random seed: #{Amaze::Algorithm.random_seed}"

    render_image if image?
  end
  
  def generate_maze
    algorithm.on grid do |stat|
      next unless visualize?

      # render grid
      ascii_options[:path_cells] = stat.current
      render_ascii

      # optional wait
      algorithm_wait stat
      break if algorithm_options[:break]
    end

    ascii_options[:path_cells] = nil
  end
  
  def algorithm_wait stat
    puts stat.info if stat.info
    sleep algorithm.speed
    sleep 1 if algorithm_options[:visualize] == :autopause && stat.pause?

    # wait for keystroke ?
    if (algorithm_options[:visualize] == :pause && stat.pause? || algorithm_options[:visualize] == :step)
      puts "[SPACE] next | [R] run algorithm | [ESC] stop algorithm"
      case read_char
      when "\e"
        algorithm_options[:break] = true
      when "r"
        algorithm_options[:visualize] = :run
      end
    end
  end
  
  def compute_distances
    return unless options[:distances]

    # Calculate the distances from a given start cell
    distances = start_cell.distances

    # Set render options
    ascii_options[:distances] = distances
    image_options[:distances] = distances
  end
  
  def compute_path
    return nil unless options[:solution] || options[:longest]
    
    start = start_cell
    finish = finish_cell

    distances = start.distances

    if options[:longest]
      # Find the cell with the max distance from the start cell
      start, _ = distances.max
      # Calculate the distances from this new cell ...
      distances = start.distances
      # ... and  find the new max distance
      finish, _ = distances.max
    end
    
    path = distances.path_to(finish).cells

    # Set render options
    ascii_options[:path_cells] = path
    image_options[:path_cells] = path
    image_options[:path_start] = start
    image_options[:path_finish] = finish
    image_options[:distances] = distances if options[:distances]

    # The length of the path
    distances[finish]
  end
  
  def render_ascii
    ascii = Amaze::Formatter::ASCII.create(options[:type], grid, ascii_options)
    puts ascii.render
  end
  
  def render_image
    image = Amaze::Formatter::Image.create(options[:type], grid, image_options)
    image.render
    image.write "maze.png"
    puts "Maze 'maze.png' saved."
  end
    
  def ascii?
    options[:formats].include? :ascii
  end
  
  def image?
    options[:formats].include? :image
  end
  
  def visualize?
    ascii? && !!algorithm_options[:visualize]
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
    @algorithm ||= Amaze::Algorithm.create algorithm_options[:algorithm]
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
    input
  ensure
    STDIN.echo = true
    STDIN.cooked!
  end
end