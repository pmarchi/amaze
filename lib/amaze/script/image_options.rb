
module Amaze::Script::ImageOptions
  
  def image_options
    @image_options ||= {
      cell_width: 100,
      wall_width: 6,
      wall_color: 'black',
      path_width: 4,
      path_color: 'red',
      border_width: 0,
      background_color: 'white',
      show_grid: false,
      hide_walls: false,
      gradient: :cold,
    }
  end

  def parser
    super
    
    opts.separator "Image Options:"

    opts.on('--cell-width PIXEL', Integer, 'The width of a cell.') do |px|
      image_options[:cell_width] = px
    end
    opts.on('--wall-width PIXEL', Integer, 'The width of the walls.') do |px|
      image_options[:wall_width] = px
    end
    opts.on('--wall-color NAME', Amaze::Formatter::Image.colors, 'The color of the walls.') do |color|
      image_options[:wall_color] = color
    end
    opts.on('--path-width PIXEL', Integer, 'The width of the path.') do |px|
      image_options[:path_width] = px
    end
    opts.on('--path-color NAME', Amaze::Formatter::Image.colors, 'The color of the path.') do |color|
      image_options[:path_color] = color
    end
    opts.on('--border-width PIXEL', Integer, 'The width of the border around the maze.') do |px|
      image_options[:border_width] = px
    end
    opts.on('--background-color NAME', Amaze::Formatter::Image.colors, 'The background color.') do |color|
      image_options[:background_color] = color
    end
    opts.on('--show-grid', 'Render the underlying grid.') do
      image_options[:show_grid] = true
    end
    opts.on('--hide-walls', "Don't render the walls.") do
      image_options[:hide_walls] = true
    end
    opts.on('--gradient NAME|FILE', String, 'The gradient map to use for the distances color.', "One of #{Amaze::Gradient.all.join(', ')}", "or a .yaml or a Photoshop .grd file") do |name|
      image_options[:gradient] = name
    end
    opts.on('--all-image-colors', 'Print all the supported image colors.') do
      puts Amaze::Formatter::Image.colors.join(', ')
      exit 0
    end
    opts.separator ""
  end
end