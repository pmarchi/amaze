
class Amaze::GradientMap::Blue < Amaze::GradientMap
  def map
    Gradient::Map.new(
      Gradient::Point.new(0, Color::RGB.new(  0,   0,  95), 1.0), # dark blue
      Gradient::Point.new(1, Color::RGB.new(255, 255, 255), 1.0), # white
    )
  end
end
