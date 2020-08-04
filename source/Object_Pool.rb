class Object_Pool
  attr_accessor :objects

  def initialize
    @objects = []
  end

  def update
    @objects.map(&:update)
  end
end