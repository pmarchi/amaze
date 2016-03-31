
class Maze::ColorGradient
  
  # The color points of the gradient as hash
  #   position => [r,g,b] # 0..255
  attr_reader :color_points
  
  def initialize
    @color_points = {
      0.0  => [  0,   0, 255], # Blue.
      0.25 => [  0, 255, 255], # Cyan.
      0.5  => [  0, 255,   0], # Green.
      0.75 => [255, 255,   0], # Yellow.
      1.0  => [255,   0,   0], # Red.
    }
  end
  
  # FIXME: values currently can go below zero and over 255
  
  def color_at value
    lower_point = color_points.keys.select {|k| k <= value }.max
    higher_point = color_points.keys.select {|k| k >= value }.min
    
    p [:lower_point, lower_point]
    p [:higher_point, higher_point]
    
    diff = higher_point - lower_point
    fraction = diff.zero? ? 0 : (value - higher_point) / diff
    
    p [:diff, diff]
    p [:frac, fraction]

    [0, 1, 2].map do |i|
      (color_points[lower_point][i] - color_points[higher_point][i]) * fraction + color_points[higher_point][i]
    end
  end
end

__END__

class ColorGradient
{
private:
  struct ColorPoint  // Internal class used to store colors at different points in the gradient.
  {
    float r,g,b;      // Red, green and blue values of our color.
    float val;        // Position of our color along the gradient (between 0 and 1).
    ColorPoint(float red, float green, float blue, float value)
      : r(red), g(green), b(blue), val(value) {}
  };
  vector<ColorPoint> color;      // An array of color points in ascending value.
 
public:
  //-- Default constructor:
  ColorGradient()  {  createDefaultHeatMapGradient();  }
 
  //-- Inserts a new color point into its correct position:
  void addColorPoint(float red, float green, float blue, float value)
  {
    for(int i=0; i<color.size(); i++)  {
      if(value < color[i].val) {
        color.insert(color.begin()+i, ColorPoint(red,green,blue, value));
        return;  }}
    color.push_back(ColorPoint(red,green,blue, value));
  }
 
  //-- Inserts a new color point into its correct position:
  void clearGradient() { color.clear(); }
 
  //-- Places a 5 color heapmap gradient into the "color" vector:
  void createDefaultHeatMapGradient()
  {
    color.clear();
    color.push_back(ColorPoint(0, 0, 1,   0.0f));      // Blue.
    color.push_back(ColorPoint(0, 1, 1,   0.25f));     // Cyan.
    color.push_back(ColorPoint(0, 1, 0,   0.5f));      // Green.
    color.push_back(ColorPoint(1, 1, 0,   0.75f));     // Yellow.
    color.push_back(ColorPoint(1, 0, 0,   1.0f));      // Red.
  }
 
  //-- Inputs a (value) between 0 and 1 and outputs the (red), (green) and (blue)
  //-- values representing that position in the gradient.
  void getColorAtValue(const float value, float &red, float &green, float &blue)
  {
    if(color.size()==0)
      return;
 
    for(int i=0; i<color.size(); i++)
    {
      ColorPoint &currC = color[i];
      if(value < currC.val)
      {
        ColorPoint &prevC  = color[ max(0,i-1) ];
        float valueDiff    = (prevC.val - currC.val);
        float fractBetween = (valueDiff==0) ? 0 : (value - currC.val) / valueDiff;
        red   = (prevC.r - currC.r)*fractBetween + currC.r;
        green = (prevC.g - currC.g)*fractBetween + currC.g;
        blue  = (prevC.b - currC.b)*fractBetween + currC.b;
        return;
      }
    }
    red   = color.back().r;
    green = color.back().g;
    blue  = color.back().b;
    return;
  }
};