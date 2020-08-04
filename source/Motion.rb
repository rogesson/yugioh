class Motion
  #[TODO] Receive object as param
  attr_accessor :object
  def initialize(position, destination, speed = 0.05, &block)
    @start = position
    @position = position
    @destination = destination
    @direction = @destination - @start
    @time_passed = 0   
    @speed = speed
    @moved = false
    @distance = distance
    @block = block if block_given?
  end

  def move
    if(Vector2d.from_points(@start, @position).magnitude >= @distance)
      @moved = true
      @position = @destination
    else
      @time_passed += 1
      @position = @position.add(direction.multiply(@speed * @time_passed))

      @position
    end
  end

  def moved?
    @moved
  end

  def execute
    @block.call if @block
  end

  private

    def distance
      Vector2d.from_points(@position, @destination).magnitude
    end

    def direction
      @direction = @destination - @start 
      @direction.normalize
      @direction
    end
end