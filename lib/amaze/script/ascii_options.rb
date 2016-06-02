
module Amaze::Script::AsciiOptions
  def ascii_options
    @ascii_options ||= { 
      cell_size: 1,
      grid_color: :white,
      path_color: :red,
    }
  end
  
  def parser
    super
    
    opts.separator "ASCII Options:"

    opts.on('-c', '--cell-size SIZE', Integer, 'The size of the cell') do |cell_size|
      ascii_options[:cell_size] = cell_size
    end
    opts.on('--ascii-grid-color NAME', Amaze::Formatter::ASCII.colors, 'The color of the grid.') do |color|
      ascii_options[:grid_color] = color
    end
    opts.on('--ascii-path-color NAME', Amaze::Formatter::ASCII.colors, 'The color of the path, when drawing the solution or longest path.') do |color|
      ascii_options[:path_color] = color
    end
    opts.on('--ascii-distances-color NAME', Amaze::Formatter::ASCII.colors, 'The color of the distances.') do |color|
      ascii_options[:distances_color] = color
    end
    opts.on('--all-ascii-colors', 'Print all supported ascii colors.') do
      puts Amaze::Formatter::ASCII.colors.map {|n| n.to_s.color(n) }.join(' ')
      exit 0
    end
    opts.on('--disable-ascii-colors', "Don't colorize ASCII mazes.") do
      Rainbow.enabled = false
    end
    opts.separator ""
  end
end
