
require 'spec_helper'

describe Amaze::Gradient do
  describe ".load" do
    
    context "an internal gradient map by name" do
      let(:arg) { :blue }
      it "returns a GradientMap" do
        expect(described_class.load arg).to be_an_instance_of Gradient::Map
      end
    end

    context "a .yaml file" do
      let(:arg) { fixture 'gradient/blue.yaml' }
      it "returns a GradientMap" do
        expect(described_class.load arg).to be_an_instance_of Gradient::Map
      end
    end

    context "a photoshop .grd file" do
      context "with a sinlge gradient" do
        let(:arg) { fixture 'gradient/cobalt-iron-3.grd' }
        it "returns a GradientMap" do
          expect(described_class.load arg).to be_an_instance_of Gradient::Map
        end
      end
      context "with multiple gradients and specifing an index" do
        let(:arg) { fixture 'gradient/2gradients.grd:1' }
        it "returns the #index-th GradientMap" do
          expect(described_class.load arg).to be_an_instance_of Gradient::Map
        end
      end
    end
    
    context "an unsupported file" do
      let(:arg) { fixture 'gradient/unsupported.gradient' }
      it "raises an exception" do
        expect{described_class.load arg}.to raise_error(RuntimeError, "Gradient file of type gradient is not supported")
      end
    end

    context "a missing file" do
      let(:arg) { fixture 'gradient/mssing.gradient' }
      it "raises an exception" do
        expect{described_class.load arg}.to raise_error(RuntimeError, "Gradient file #{arg} not found")
      end
    end
  end
  
  describe ".all" do
    it "returns a list of all built-in gradients" do
      expect(described_class.all).to include(*%w( blue cold gold green monochrome red warm cobalt-iron-3 ))
    end
  end
end