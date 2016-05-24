
require 'spec_helper'

describe Amaze::Shape::Star do
  context "class" do
    it "has a label" do
      expect(Amaze::Shape.all).to include :star
    end
  end
  
  let(:star) { Amaze::Shape::Star.new 3 }

  it "#initialize accepts a size" do
    expect(star.size).to eq 3
  end
  
  [[1,7], [2,11], [3,19], [4,23], [5,31]].each do |size, columns|
    context "with size = #{size}" do
      let(:star) { Amaze::Shape::Star.new size }

      it "#rows are equal #{size*4}" do
        expect(star.rows).to eq size*4
      end

      it "#columns are equal #{columns}" do
        expect(star.columns).to eq columns
      end

      it "#to_s returns a #{size*4}x#{columns} mask of a star" do
        expect(star.to_s).to eq(read_fixture "shape/star#{size}.txt")
      end
    end
  end
end