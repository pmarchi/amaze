
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
  
  [[1,3], [2,3], [3,7], [4,7], [5,11]].each do |size, columns|
    context "with size = #{size}" do
      let(:diamond) { Amaze::Shape::Diamond.new size }
      it "#rows are equal #{size}" do
        expect(diamond.rows).to eq size*2
      end
  
      it "#columns are equal #{columns}" do
        expect(diamond.columns).to eq(columns)
      end
      
      it "#to_s returns a #{size}x#{columns} mask of a diamond" do
        expect(diamond.to_s).to eq(read_fixture "shape/diamond#{size}.txt")
      end
    end
  end
end