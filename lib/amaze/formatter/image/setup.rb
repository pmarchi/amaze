
module Amaze::Formatter::Image::Setup
  
  def setup_background
    setup_defaults
    canvas.stroke 'none'
  end
  
  def setup_grid
    setup_defaults
    canvas.stroke 'gray90'
    canvas.stroke_width 1
  end
  
  def setup_wall
    setup_defaults
    canvas.stroke wall_color
    canvas.stroke_width wall_width
  end
  
  def setup_path
    setup_defaults
    canvas.stroke path_color
    canvas.stroke_width path_width
  end
  
  def setup_path_endpoints
    setup_defaults
    canvas.fill path_color
    canvas.stroke 'none'
  end
  
  def setup_defaults
    canvas.stroke_antialias true
    canvas.stroke_linecap canvas_options[:linecap] if canvas_options[:linecap]
    canvas.stroke_linejoin canvas_options[:linejoin] if canvas_options[:linejoin]
    canvas.fill 'none'
  end
end