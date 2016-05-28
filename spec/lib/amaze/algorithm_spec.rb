
require 'spec_helper'

describe Amaze::Algorithm do
  
  context "registred without options" do
    before(:example) do
      class Sub1 < Amaze::Algorithm
        register :sub1
      end
    end

    it "registers with a specifc name" do
      expect(Amaze::Algorithm.registred.keys).to include :sub1
    end
    
    it "stores the class" do
      expect(Amaze::Algorithm.registred[:sub1]).to include(class: Sub1)
    end
    
    it "create instantiats the class" do
      expect(Amaze::Algorithm.create :sub1).to be_an_instance_of(Sub1)
    end
  end
  
  context "registred with options" do
    before(:example) do
      class Sub1 < Amaze::Algorithm
        register :sub1, configuration: "conf", message: "message"
      end
    end

    it "stores the class and the options" do
      expect(Amaze::Algorithm.registred[:sub1]).to include(class: Sub1, options: {configuration: "conf", message: "message"} )
    end

    it "create instantiats the class" do
      expect(Amaze::Algorithm.create :sub1).to be_an_instance_of(Sub1)
    end
    
    it "create sets the stored options" do
      expect(Amaze::Algorithm.create(:sub1).options).to eq({configuration: "conf", message: "message"})
    end
  end
  
  context ".all" do
    before(:example) do
      class SubA < Amaze::Algorithm; register :a1; register :a2; end
      class SubB < Amaze::Algorithm; register :b; end
    end
    it "return a list of registred algorithms" do
      expect(Amaze::Algorithm.all).to include(:a1, :a2, :b)
    end
  end
  
  context ".random_seed" do
    context "not set to a specific value" do
      before(:example) do
        Amaze::Algorithm.new
      end
    
      it "returns a random value" do
        expect(Amaze::Algorithm.random_seed).to be_a(Bignum)
      end
    end
    
    context "set to a specific value" do
      let(:seed) { 8 }
      let(:random_sequence) { srand seed; [rand, rand, rand] }

      before(:example) do
        Amaze::Algorithm.random_seed = seed
        Amaze::Algorithm.new
      end
   
      it "returns the given value" do
        expect(Amaze::Algorithm.random_seed).to eq seed
      end

      it "produces the same sequence of random values" do
        expect([rand, rand, rand]).to eq random_sequence
      end
    end
  end
end