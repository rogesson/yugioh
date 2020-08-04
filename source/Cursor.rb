class Cursor
  def initialize(object, src_sprite)
    @object         = object
    @state          = :decrease
    @src_sprite     = src_sprite
    @forced_objects = []

    @x = @object.x
    @y = @object.y
    @selected_object = nil
    @old_object = nil

    @active = false
    
    create_sprite
    hide
  end

  def deactivate
    @sprite.visible = false
    @active = false
  end

  def hide
    @sprite.visible = false
  end

  def show
    @sprite.visible = true
  end

  def activate
    @sprite.visible = true
    @active = true
    new_current_obj(@object)
  end

  def active?
    @active
  end

  def create_sprite
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new("Graphics/System/default_cursor.png")
    @sprite.src_rect.set(0, 0, 20, 23)
    @sprite.x = @x
    @sprite.y = @y
    @sprite.z = 401
  end

  def move_to(side)
    if @object.board_player == :player_2
      side = case side
      when :UP
        :DOWN
      when :DOWN
        :UP
      when :LEFT
        :RIGHT
      when :RIGHT
        :LEFT
      end
    end

    if @object.respond_to?("move_#{side.downcase}")
      new_object = @object.send("move_#{side.downcase}")
      new_current_obj(new_object)
    end
  end

  def new_current_obj(new_object)
    @object = new_object

    leave_old_object

    if @object.respond_to?(:selected_object) && @object.selected_object
      @selected_object = @object.selected_object
    else
      @selected_object = @object
    end

    @selected_object.on_hover

    puts "Board: #{@object.board_player} Current Object: #{@object} Childen: #{@selected_object}"

    center_x =  (@selected_object.width / 2)
    center_y  = (@selected_object.height / 2)
        
    if @old_object.nil?
      @position = Vector2d.new(@selected_object.x + center_x, @selected_object.y + center_y)
    else
      @position = Vector2d.new(@old_object.x + center_x, @old_object.y + center_y)
    end

    if @old_object.is_a?(Hand)
      @position = Vector2d.new(@selected_object.x + center_x,  @selected_object.y + center_y)
    end

    @destination = Vector2d.new(@selected_object.x + center_x,  @selected_object.y + center_y)

    @motion = Motion.new(@position, @destination, 0.2)
  end

  def perform_ok
    @object.perform_ok
  end

  def update
    #[TODO] fazer update apernas se mudar o objeto
    return if not @active
    return if @old_object.nil?
    return if not @object.respond_to?(:selected_object)
    return if @motion.moved?
    
    position = @motion.move

    @sprite.x = position.x
    @sprite.y = position.y
  end


  def terminate
    @sprite.dispose
  end

  private

    def leave_old_object
      if @selected_object && @selected_object.class != @object.class
        @old_object = @selected_object
        @selected_object.on_leave if @selected_object.respond_to?(:on_leave)
      end
    end
end

class Point
  
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end
