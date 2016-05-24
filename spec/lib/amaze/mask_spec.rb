
require 'spec_helper'

describe Amaze::Mask do
  
  context ".new" do
    before(:example) do
      @mask = Amaze::Mask.new 2, 2
    end
    
    it "returns a mask" do
      expect(@mask).to be_an_instance_of Amaze::Mask
    end
  
    it "returns all cells on" do
      (0...2).each do |row|
        (0...2).each do |column|
          expect(@mask[row, column]).to be true
        end
      end
    end
  end
  
  context ".from_string" do
    let(:triangle2) { read_fixture 'shape/triangle2.txt' }
    let(:mask) { Amaze::Mask.from_string triangle2 }
    
    it "accepts a string argument" do
      expect(mask).to be_truthy
    end
    
    it "returns a mask" do
      expect(mask).to be_an_instance_of Amaze::Mask
    end
    
    it "with rows equal lines" do
      expect(mask.rows).to eq(triangle2.lines.count)
    end
    
    it "and columns equal the length of the first line" do
      expect(mask.columns).to eq(triangle2.lines.first.chomp.length)
    end
    
    it "turns off the marked cells" do
      expect(mask[0,0]).to be false
      expect(mask[0,2]).to be false
    end
  end
  
  context ".from_file" do
    context ".txt" do
      let(:mask) { Amaze::Mask.from_file(fixture 'mask/mask.txt') }
    
      it "turns off the marked cells" do
        expect(mask[0,1]).to be false
        expect(mask[1,0]).to be false
      end
    end

    context ".png" do
      let(:mask) { Amaze::Mask.from_file(fixture 'mask/mask.png') }
    
      it "turns off the marked cells" do
        expect(mask[0,0]).to be false
        expect(mask[3,0]).to be false
        expect(mask[0,3]).to be false
        expect(mask[3,3]).to be false
      end
    end
    
    context ".gif" do
      let(:mask) { Amaze::Mask.from_file 'mask.gif' }
      
      it "raises an error" do
        expect { mask }.to raise_error(RuntimeError, "Mask file of type gif is not supported.")
      end
    end
  end
  
  context "#count" do
    
    before(:example) do
      @mask = Amaze::Mask.from_string "X.X\n.X.\n"
    end
    
    it "counts only the cells that are on" do
      expect(@mask.count).to eq 3
    end
  end
end