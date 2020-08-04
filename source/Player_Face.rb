class Player_Face
  def initialize(player, face_image_name, x, y)
    @player = player
    @face_image_name = face_image_name
    @sprite = Sprite_Base.new
    @sprite.x = x
    @sprite.y = y
  end

  def draw
    bitmap = face_frame_bitmap 
    sprite.bitmap = Bitmap.new("Graphics/Faces/#{face_image_name}.png")
    sprite.bitmap.blt(0, 0, bitmap, bitmap.rect)

    sprite.mirror = true if player == :player_2

    true
  end

  def terminate
    sprite.dispose
  end

  def update
    sprite.update
  end

  def receive_damage(element)
    animation = Animation.find(element)
    sprite.start_animation(animation)

    true
  end

  private

    attr_reader :sprite, :face_image_name, :face_frame_bitpmap, :player

    def face_frame_bitmap
      face = player == :player_1 ? 'player_face_frame' : 'oponnet_face_frame'

      Bitmap.new("Graphics/System/#{face}")
    end

    #[TODO] Create animation class
    #def animations
    #  $data_animations
    #end
end