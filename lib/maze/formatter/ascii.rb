
class Maze::Formatter::Ascii
  autoload :Delta, 'maze/formatter/ascii/delta'
  autoload :Ortho, 'maze/formatter/ascii/ortho'
  autoload :Sigma, 'maze/formatter/ascii/sigma'
  
  # The size of a sigle cell
  attr_reader :cell_size
  
  def initialize options={}
    @cell_size = options.fetch(:cell_size, 1)
  end
end