
class Amaze::GradientMap::Monochrome < Amaze::GradientMap
  def map
    Gradient::Map.new(
      Gradient::Point.new(0, Color::RGB.new(  0,   0,   0), 1.0), # black
      Gradient::Point.new(1, Color::RGB.new(255, 255, 255), 1.0), # white
    )
  end
end
