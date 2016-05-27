
class Amaze::Factory

  # The type of the grid
  attr_reader :type
  
  def initialize type
    raise "#{type} maze is not supported" unless Amaze::Grid.all.include? type
    @type = type
  end
  
  # All known algorithms
  def self.algorithms
    %i( bt sw ab gt1 gt2 gt3 gt4 w hk rb1 rb2 )
  end
  
  def create_algorithm algorithm
    raise "#{algorithm} is not supported" unless self.class.algorithms.include? algorithm
    
    # Alogrithms for all mazes
    select = {
      ab:  Amaze::Algorithm::AldousBorder,
      gt1: Amaze::Algorithm::GrowingTree,
      gt2: Amaze::Algorithm::GrowingTree,
      gt3: Amaze::Algorithm::GrowingTree,
      gt4: Amaze::Algorithm::GrowingTree,
      w:   Amaze::Algorithm::Wilson,
      hk:  Amaze::Algorithm::HuntAndKill,
      rb1: Amaze::Algorithm::RecursiveBacktracker,
      rb2: Amaze::Algorithm::RecursiveBacktracker,
    }
    
    # Algorithms only for ortho mazes
    select.merge!(
      bt: Amaze::Algorithm::BinaryTree,
      sw: Amaze::Algorithm::Sidewinder
    ) if type == :ortho
    
    raise "Alogrithm not supported on #{type} maze." unless select[algorithm]
    instance = select[algorithm].new

    case algorithm
    when :gt1
      instance.configure "last from list", proc {|active| active.last }
    when :gt2
      instance.configure "random from list", proc {|active| active.sample }
    when :gt3
      instance.configure "last/random 1/1 from list", proc {|active| (rand(2) > 0) ? active.last : active.sample }
    when :gt4
      instance.configure "last/random 2/1 from list", proc {|active| (rand(3) > 0) ? active.last : active.sample }
    when :rb1
      instance.configure :stack
    when :rb2
      instance.configure :recursion
    end
    
    instance 
  end
end