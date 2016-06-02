
require 'yaml'
require 'gradient'

class Amaze::Gradient
  
  def self.load name_or_file
    name_or_file, index = name_or_file.to_s.split(/:(?=\d+$)/)
    file = path(name_or_file)
    
    if file
      ext = File.extname(file)[1..-1].downcase
      method_name = "load_#{ext}"
      args = [file, index].compact
      if self.respond_to? method_name
        send method_name, *args
      else
        raise "Gradient file of type #{ext} is not supported"
      end
    else
      raise "Gradient file #{name_or_file} not found"
    end
  end
  
  def self.load_yaml file
    Gradient::Map.deserialize(YAML.load_file file)
  end
  
  def self.load_grd file, index=nil
    Gradient::GRD.read(file).values[index.to_i]
  end
  
  def self.path name_or_file
    share =  File.expand_path "../../../share/gradient", __FILE__
    [name_or_file, File.join(share, "#{name_or_file}.yaml"), File.join(share, name_or_file)].find do |file|
      File.exist? file
    end
  end
  
  def self.all
    %w( blue cold gold green monochrome red warm cobalt-iron-3 )
  end
end