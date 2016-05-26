
require 'spec_helper'

describe Amaze::Shape do
  let(:shape) { Amaze::Shape.new 3 }
  
  context "initialize" do
    it "accepts a size" do
      expect(shape.size).to eq 3
    end
  end
  
  context "on(N)" do
    it "returns an Array of N '.'" do
      expect(shape.on 3).to eq %w( . . . )
    end
  end

  context "off(N)" do
    it "returns an Array of N 'X'" do
      expect(shape.off 5).to eq %w( X X X X X )
    end
  end
  
  context "to_s with a 3x3 Array" do
    before(:example) do
      allow(shape).to receive(:chars) {
        [%w( . . . ), %w( X X X ), %w( . . . )]
      }
    end
    it "returns a string of 3 lines with each 3 chars" do
      expect(shape.to_s).to eq "...\nXXX\n..."
    end
  end
end