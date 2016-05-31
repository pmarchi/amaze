
module Amaze::Script::AlgorithmOptions
  def algorithm_options
    @algorithm_options ||= { 
      algorithm: :rb1,
      visualize: false,
    }
  end
  
  def parser
    super
    
    opts.separator "Algorithm options:"

    opts.on('-a', '--algorithm ALGORITHM', Amaze::Algorithm.all, 'The algorithm to generate the maze.', "One of #{Amaze::Algorithm.all.join(', ')}") do |algorithm|
      algorithm_options[:algorithm] = algorithm
    end
    opts.on('-S', '--seed SEED', Integer, 'Set random seed') do |seed|
      Amaze::Algorithm.random_seed = seed
    end
    opts.on('-v', '--visualize [MODE]', visualization_modes, 'Visualize the progress of the algorithm', "One of #{visualization_modes.join(', ')}") do |mode|
      algorithm_options[:visualize] = mode || :run
    end
    opts.separator ""
  end
  
  def visualization_modes
    %i( run autopause pause step )
  end
end
