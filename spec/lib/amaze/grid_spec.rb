
require 'spec_helper'

describe Amaze::Grid do
  context ".all" do
    it "includes the lowercase name of subclasses" do
      class Amaze::Grid::Test < described_class; end
      expect(described_class.all).to include :test
    end
  end
end