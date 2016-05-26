
require 'spec_helper'

describe Amaze::GradientMap do
  described_class.all.each do |map_name|
    context ".create(:#{map_name}).map" do
      it "returns a #{Gradient::Map}" do
        expect(described_class.create(map_name).map).to be_an_instance_of Gradient::Map
      end
    end
  end
end

