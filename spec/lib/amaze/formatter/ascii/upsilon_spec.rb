
require 'spec_helper'

describe Amaze::Formatter::ASCII::Upsilon do
  let(:type) { :upsilon }
  
  def prepare_maze
    Amaze::Grid.create(type, 3, 3).tap do |g|
      g[0,1].link g[0,0]
      g[0,0].link g[1,1]
      g[1,1].link g[0,2]
      g[0,2].link g[1,2]
      g[1,2].link g[2,2]
      g[2,2].link g[2,1]
      g[2,1].link g[2,0]
      g[2,0].link g[1,0]
    end
  end
  
  def prepare_path grid
    [
      grid[0,0], 
      grid[0,1], 
      grid[0,2], 
      grid[1,0], 
      grid[1,1], 
      grid[2,0], 
      grid[2,1], 
      grid[2,2],
    ]
  end

  def compare_ascii char_array, reference
    expect(char_array.map{|l| l.join }.join("\n")).to eq reference
  end
  
  def remove_grid path_with_grid, grid
    path = path_with_grid.chars
    grid.chars.each_with_index do |c, i|
      path[i] = ' ' if path[i] == c && c != "\n"
    end
    path.join
  end
  
  let(:grid) { prepare_maze }
  let(:path) { prepare_path grid }
  let(:formatter) { Amaze::Formatter::ASCII.create type, grid, options }
  
  (1..3).each do |cell_size|
    context "with cell size #{cell_size}" do
      let(:options) { {cell_size: cell_size} }
      let(:reference_grid) { read_fixture "maze/ascii/#{type}/grid#{cell_size}.txt" }
      let(:reference_distances) { remove_grid read_fixture("maze/ascii/#{type}/distances#{cell_size}.txt"), reference_grid }
      let(:reference_path) { remove_grid read_fixture("maze/ascii/#{type}/path#{cell_size}.txt"), reference_grid }

      context "#render_cells" do
        before(:example) do
          formatter.render_cells
        end
      
        it "draws ascii grid" do
          compare_ascii formatter.char, reference_grid
        end
      end
      
      # context "render_distances" do
      #   let(:distances) { grid[0,0].distances }
      #   let(:options) { {cell_size: cell_size, distances: distances} }
      #   before(:example) do
      #     formatter.render_distances
      #   end
      #
      #   it "draws the distances inside the cells" do
      #     compare_ascii formatter.char, reference_distances
      #   end
      # end
      
      # context "#render_path" do
      #   let(:options) { {cell_size: cell_size, path_cells: path} }
      #   before(:example) do
      #     formatter.render_path
      #   end
      #
      #   it "draws the path through the maze" do
      #     compare_ascii formatter.char, reference_path
      #   end
      # end
    end
  end
end