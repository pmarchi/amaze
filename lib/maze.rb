require "maze/version"

module Maze
  autoload :Script, 'maze/script'
  autoload :Factory, 'maze/factory'
  autoload :Cell, 'maze/cell'
  autoload :Grid, 'maze/grid'
  autoload :SigmaCell, 'maze/sigma_cell'
  autoload :SigmaGrid, 'maze/sigma_grid'
  autoload :DeltaGrid, 'maze/delta_grid'
  autoload :Algorithm, 'maze/algorithm'
  autoload :Formatter, 'maze/formatter'
  autoload :Distances, 'maze/distances'
  autoload :Mask, 'maze/mask'
  autoload :MaskedGrid, 'maze/masked_grid'
  autoload :Shape, 'maze/shape'
end
