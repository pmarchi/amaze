
require 'spec_helper'

describe Amaze::Shape::Triangle do
  context "class" do
    it "has a label" do
      expect(Amaze::Shape.all).to include :triangle
    end
  end
  
  let(:triangle) { Amaze::Shape::Triangle.new 3 }
  
  it "#initialize accepts a size" do
    expect(triangle.size).to eq 3
  end
  
  [[1,3], [2,3], [3,7], [4,7], [5,11]].each do |size, columns|
    context "with size = #{size}" do
      let(:triangle) { Amaze::Shape::Triangle.new size }
      it "#rows are equal #{size}" do
        expect(triangle.rows).to eq size
      end
  
      it "#columns are equal #{columns}" do
        expect(triangle.columns).to eq(columns)
      end
      
      it "#to_s returns a #{size}x#{columns} mask of a triangle" do
        expect(triangle.to_s).to eq(read_fixture "shape/triangle#{size}.txt")
      end
    end
  end
end