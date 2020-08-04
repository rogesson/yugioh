class Card_Graphics < Component

  BITMAP_CARD_FACE_UP   = 'Graphics/Pictures/card_face_up.png'
  BITMAP_CARD_MOVIMENTS = 'Graphics/Pictures/card_moviments.png'

  attr_accessor :bright
  attr_reader :sprite

  def initialize(game_object)
    super

    @current_frame = 0
    @game_object = game_object
    
    @sprite = Sprite_Base.new #Sprite.new
    @sprite.visible = false
    @sprite.x = game_object.x
    @sprite.y = game_object.y
    @sprite.z = 300
    @bright   = false
  end

  def face_down
    @sprite.bitmap = Bitmap.new(BITMAP_CARD_MOVIMENTS)
    @sprite.src_rect.set(388, 0, @game_object.width, @game_object.height)
  end

  def face_up
    @sprite.bitmap = Bitmap.new(BITMAP_CARD_FACE_UP)
    card_img_pos = @game_object.width * card_sprite_position.fetch(@game_object.type)

    @sprite.src_rect.set(card_img_pos, 0, @game_object.width, @game_object.height)
    # Monster image 14x15
    bitmap_img = Bitmap.new("Graphics/Pictures/Cards/image/#{@game_object.id}")    
    @sprite.bitmap.blt(card_img_pos + 5, 8, bitmap_img, bitmap_img.rect)
  end

  def ready_to_atk
    @sprite_atk_icon = Sprite.new
    @sprite_atk_icon.bitmap = Bitmap.new("Graphics/System/sword.png")
    @sprite_atk_icon.src_rect.set(0, 0, 24, 24)
    @sprite_atk_icon.x = @game_object.x
    @sprite_atk_icon.y = @game_object.y
    @sprite_atk_icon.z = 301

    #create_monster_sprite
  end

  def create_monster_sprite
    #@sprite_monster = Sprite.new
    #@sprite_monster.bitmap = Bitmap.new("Graphics/Pictures/blue_eyes_white_dragon") 
    #@sprite_monster.x = @game_object.x - 20
    #@sprite_monster.y = @game_object.y - 30
    #@sprite_monster.z = 302
  end

  def z=(position)
    @sprite.z = position
  end

  def to_atk
    @sprite.angle = 360
  end

  def to_def
    @sprite.angle = 90
  end

  def show
    @sprite.visible = true
  end

  def dispose
    @sprite.dispose
    @sprite_atk_icon.dispose if @sprite_atk_icon
    @sprite_monster.dispose if @sprite_monster
  end

  def remove_icons
    @sprite_atk_icon.dispose if @sprite_atk_icon
    @bright = false
  end

  def update
    bright_card if @bright
    @sprite.update

    if @sprite.x == @game_object.x && @sprite.y == @game_object.y
      return
    end
    
    @sprite.x = @game_object.x
    @sprite.y = @game_object.y
  end

  def bright_card
    if @sprite.opacity < 100
      @state = :increase
    end

    if @sprite.opacity >= 250
      @state = :decrease
    end

    if @state == :increase
      @sprite.opacity += 4
    else
      @sprite.opacity -= 4
    end
  end

  private

    def card_sprite_position
      {
        'Normal Monster' => 0,
        'Effect Monster' => 1,
        'Flip Effect Monster' => 1,
        'XYZ Monster' => 1,
        'Toon Monster' => 1,
        'Fusion Monster' => 2,
        'Ritual Monster' => 3,
        'Trap Card' => 4,
        'Spell Card' => 5
      }
    end
end
