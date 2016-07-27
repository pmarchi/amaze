require 'spec_helper'

shared_examples "ascii maze" do

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

      context "#render_cells" do
        before(:example) do
          formatter.render_cells
        end
      
        it "draws the ascii grid" do
          compare_ascii formatter.char, reference_grid
        end
      end
      
      context "#render_distances" do
        let(:distances) { grid[0,0].distances }
        let(:options) { {cell_size: cell_size, distances: distances} }
        let(:reference_distances) { remove_grid read_fixture("maze/ascii/#{type}/distances#{cell_size}.txt"), reference_grid }

        before(:example) do
          formatter.render_distances
        end

        it "writes the distances inside the cells" do
          compare_ascii formatter.char, reference_distances
        end
      end
      
      context "#render_path" do
        let(:options) { {cell_size: cell_size, path_cells: path} }
        let(:reference_path) { remove_grid read_fixture("maze/ascii/#{type}/path#{cell_size}.txt"), reference_grid }

        before(:example) do
          formatter.render_paths
        end

        it "draws the path through the maze" do
          compare_ascii formatter.char, reference_path
        end
      end
    end
  end
end