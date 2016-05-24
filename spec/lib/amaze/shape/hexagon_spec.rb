
require 'spec_helper'

describe Amaze::Shape::Hexagon do
  context "class" do
    it "has a label" do
      expect(Amaze::Shape.all).to include :hexagon
    end
  end
  
  let(:hexagon) { Amaze::Shape::Hexagon.new 3 }

  it "#initialize accepts a size" do
    expect(hexagon.size).to eq 3
  end
  
  [[1,5], [2,7], [3,13], [4,15], [5,21]].each do |size, columns|
    context "with size = #{size}" do
      let(:hexagon) { Amaze::Shape::Hexagon.new size }

      it "#rows are equal #{size*2}" do
        expect(hexagon.rows).to eq size*2
      end

      it "#columns are equal #{columns}" do
        expect(hexagon.columns).to eq columns
      end

      it "#to_s returns a #{size*2}x#{columns} mask of a hexagon" do
        expect(hexagon.to_s).to eq(read_fixture "shape/hexagon#{size}.txt")
      end
    end
  end
end