
require 'gradient'

class Amaze::GradientMap
  def self.inherited child_class
    name = child_class.to_s.split('::').last.split(/(?=[[:upper:]])/).map(&:downcase).join
    (@@names ||= {})[name.to_sym] = child_class
  end
  
  def self.all
    @@names.keys
  end
  
  def self.create name
    @@names[name.to_sym].new.map
  end
end

require 'amaze/gradient_map/blue'
require 'amaze/gradient_map/cold'
require 'amaze/gradient_map/gold'
require 'amaze/gradient_map/green'
require 'amaze/gradient_map/monochrome'
require 'amaze/gradient_map/red'
require 'amaze/gradient_map/warm'