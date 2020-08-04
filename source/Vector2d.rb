class Vector2d
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "Vector(#{@x}, #{@y})"
  end

  def self.from_points_old(point_1, point_2)
    self.new(point_2[0] - point_1[0], point_2[1] - point_1[1])
  end

  def self.from_points(point_1, point_2)
    self.new(point_2.x - point_1.x, point_2.y - point_1.y)
  end

  def add(vector)
    Vector2d.new(@x + vector.x, @y + vector.y)
  end

  def -(vector)
    Vector2d.new(@x - vector.x, @y - vector.y)
  end

  def multiply(scalar)
    Vector2d.new(@x * scalar, @y * scalar)
  end
  
  def magnitude
    mag = Math.sqrt(@x * @x + @y * @y)
    mag
  end

  def normalize
    mag = magnitude
    @x /= mag
    @y /= mag
 
  end
end