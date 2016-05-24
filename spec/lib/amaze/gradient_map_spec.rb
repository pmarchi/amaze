
require 'spec_helper'

describe Amaze::GradientMap do
  context ".all" do
    it "includes the name of subclasses" do
      class Amaze::GradientMap::Warm < described_class; end
      expect(described_class.all).to include :warm
    end
  end

  described_class.all.each do |map_name|
    context "map: #{map_name}" do
      it "returns a #{Gradient::Map}" do
        expect(described_class.create map_name).to be_an_instance_of Gradient::Map
      end
    end
  end
end

