
require 'spec_helper'

describe Amaze::Shape::Cross do
  context "class" do
    it "has a label" do
      expect(Amaze::Shape.all).to include :cross
    end
  end
  
  let(:cross) { Amaze::Shape::Cross.new 3 }

  it "#initialize accepts a size" do
    expect(cross.size).to eq 3
  end
  
  (1..4).each do |size|
    context "with size = #{size}" do
      let(:cross) { Amaze::Shape::Cross.new size }

      it "#rows are equal #{size*3}" do
        expect(cross.rows).to eq size*3
      end

      it "#columns are equal #{size*3}" do
        expect(cross.columns).to eq size*3
      end

      it "#to_s returns a #{size*3}x#{size*3} mask of a cross" do
        expect(cross.to_s).to eq(read_fixture "shape/cross#{size}.txt")
      end
    end
  end
end