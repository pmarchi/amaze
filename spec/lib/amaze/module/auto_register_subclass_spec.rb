
require 'spec_helper'

class Parent
  extend Amaze::Module::AutoRegisterSubclass
end
class Child1 < Parent; end
class Child2 < Parent; end

describe Amaze::Module::AutoRegisterSubclass do
  it "registers the class in a hash by name" do
    expect(Parent.registred.keys).to include :child1
    expect(Parent.registred[:child1]).to eq Child1
  end
  
  it ".all includes the names of all subclasses" do
    expect(Parent.all).to include :child1
    expect(Parent.all).to include :child2
  end
  
  it "creates an new instance of a subclass by name" do
    expect(Parent.create(:child1)).to be_an_instance_of Child1
  end
end