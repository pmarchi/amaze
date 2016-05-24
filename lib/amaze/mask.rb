
require 'chunky_png'

class Amaze::Mask
  
  # The rows and columns of the mask
  attr_reader :rows, :columns
  
  def initialize rows, columns
    @rows, @columns = rows, columns
    @bits = Array.new(@rows) { Array.new(@columns, true) }
  end
  
  def [](row, column)
    if row.between?(0, rows - 1) && column.between?(0, columns - 1)
      @bits[row][column]
    else
      false
    end
  end
  
  def []=(row, column, is_on)
    @bits[row][column] = is_on
  end
  
  def count
    count = 0
    
    rows.times do |row|
      columns.times do |column|
        count += 1 if @bits[row][column]
      end
    end
    count
  end
  
  def random_location
    loop do
      row = rand(rows)
      column = rand(columns)
      return [row, column] if @bits[row][column]
    end
  end
  
  def self.from_file file
    ext = File.extname(file)[1..-1].downcase
    method_name = "from_#{ext}"
    if self.respond_to? method_name
      send method_name, file
    else
      raise "Mask file of type #{ext} is not supported."
    end
  end
  
  def self.from_txt file
    from_string File.read(file)
  end
  
  def self.from_string string
    lines = string.lines.map(&:strip)
    lines.pop while lines.last.length < 1
    
    rows = lines.count
    columns = lines.first.chomp.length
    mask = new rows, columns
    
    mask.rows.times do |row|
      mask.columns.times do |column|
        mask[row,column] = lines[row][column] != 'X'
      end
    end
    
    mask
  end

  def self.from_png file
    image = ChunkyPNG::Image.from_file file
    mask = new image.height, image.width

    mask.rows.times do |row|
      mask.columns.times do |column|
        mask[row,column] = image[column, row] != ChunkyPNG::Color::BLACK
      end
    end
    
    mask
  end

end