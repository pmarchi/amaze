
require 'spec_helper'

class ParentFoo
  extend Amaze::Module::AutoRegisterSubclass
end
class ChildFoo1 < ParentFoo; end
class ChildFoo2 < ParentFoo; end

class ParentBar
  extend Amaze::Module::AutoRegisterSubclass
end
class ChildBar1 < ParentBar; end
class ChildBar2 < ParentBar; end


describe Amaze::Module::AutoRegisterSubclass do
  it "registers the class in a hash by name" do
    expect(ParentFoo.registred.keys).to include :childfoo1
    expect(ParentFoo.registred[:childfoo1]).to eq ChildFoo1
  end
  
  it ".all includes the names of all subclasses" do
    expect(ParentFoo.all).to include :childfoo1
    expect(ParentFoo.all).to include :childfoo2
  end
  
  it "creates an new instance of a subclass by name" do
    expect(ParentFoo.create(:childfoo1)).to be_an_instance_of ChildFoo1
  end
  
  it "does not register names of children of other parents" do
    expect(ParentFoo.all).not_to include :childbar1
  end
end