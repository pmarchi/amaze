
require 'spec_helper'

describe Amaze::Shape::Diamond do
  context "class" do
    it "has a label" do
      expect(Amaze::Shape.all).to include :diamond
    end
  end
  
  let(:diamond) { Amaze::Shape::Diamond.new 3 }
  
  it "#initialize accepts a size" do
    expect(diamond.size).to eq 3
  end
  
  (1..5).each do |size|
    context "with size = #{size}" do
      let(:star) { Amaze::Shape::Diamond.new size }
      let(:mask) { read_fixture "shape/diamond#{size}.txt" }
      let(:rows) { mask.lines.size }
      let(:columns) { mask.lines.first.chomp.size }

      it "#rows match the rows of the fixture" do
        expect(star.rows).to eq rows
      end
  
      it "#columns match the rows of the fixture" do
        expect(star.columns).to eq columns
      end
      
      it "#to_s returns the same mask as the fixture" do
        expect(star.to_s).to eq mask
      end
    end
  end
end