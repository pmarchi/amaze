
class Amaze::GradientMap::Red < Amaze::GradientMap
  def map
    Gradient::Map.new(
      Gradient::Point.new(0, Color::RGB.new( 95,   0,   0), 1.0), # dark red
      Gradient::Point.new(1, Color::RGB.new(255, 255, 255), 1.0), # white
    )
  end
end
