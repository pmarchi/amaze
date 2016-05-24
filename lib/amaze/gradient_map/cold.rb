
class Amaze::GradientMap::Cold < Amaze::GradientMap
  def map
    Gradient::Map.new(
      Gradient::Point.new(0,    Color::RGB.new(  0,   0,  95), 1.0), # blue
      Gradient::Point.new(0.65, Color::RGB.new(  0, 191, 255), 1.0), # cyan
      Gradient::Point.new(1,    Color::RGB.new(255, 255, 255), 1.0), # white
    )
  end
end
