
class Amaze::GradientMap::Gold < Amaze::GradientMap
  def map
    Gradient::Map.new(
      Gradient::Point.new(0,    Color::RGB.new(127,   0,   0), 1.0), # dark red
      Gradient::Point.new(0.5,  Color::RGB.new(255, 127,   0), 1.0), # light red yellow
      Gradient::Point.new(0.75, Color::RGB.new(255, 255,   0), 1.0), # yellow
      Gradient::Point.new(1,    Color::RGB.new(255, 255, 255), 1.0), # white
    )
  end
end
