
require 'spec_helper'
require 'support/shared_examples/ascii_maze'

describe Amaze::Formatter::ASCII::Sigma do
  
  def prepare_maze
    Amaze::Grid.create(type, 3, 3).tap do |g|
      g[0,0].link g[0,1]
      g[0,1].link g[0,2]
      g[0,2].link g[1,2]
      g[1,2].link g[2,2]
      g[2,2].link g[1,1]
      g[1,1].link g[1,0]
      g[1,0].link g[2,0]
      g[2,0].link g[2,1]
    end
  end
  
  def prepare_path grid
    [
      grid[0,1],
      grid[0,2],
      grid[1,2],
      grid[2,2],
      grid[1,1],
      grid[1,0],
      grid[2,0],
    ]
  end

  include_examples "ascii maze" do
    let(:type) { :sigma }
  end
end