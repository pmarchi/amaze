
require 'spec_helper'

describe Amaze::Shape::Triangle do
  let(:triangle) { Amaze::Shape::Triangle.new 3 }
  
  it "#initialize accepts a size" do
    expect(triangle.size).to eq 3
  end
  
  (1..5).each do |size|
    context "with size = #{size}" do
      let(:triangle) { Amaze::Shape::Triangle.new size }
      let(:mask) { read_fixture "shape/triangle#{size}.txt" }
      let(:rows) { mask.lines.size }
      let(:columns) { mask.lines.first.chomp.size }

      it "#rows match the rows of the fixture" do
        expect(triangle.rows).to eq rows
      end
  
      it "#columns match the rows of the fixture" do
        expect(triangle.columns).to eq columns
      end
      
      it "#to_s returns the same mask as the fixture" do
        expect(triangle.to_s).to eq mask
      end
    end
  end
end