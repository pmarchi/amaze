
require 'spec_helper'

describe Amaze::Grid do
  context ".all" do
    it "includes the lowercase name of subclasses" do
      class Amaze::Grid::Test < described_class; end
      expect(described_class.all).to include :test
    end
  end
  
  context "initialize" do
    it "should raise a NotImplementedError" do
      expect{ described_class.new 3, 4 }.to raise_error(NotImplementedError)
    end
  end
end