class Information_Zone
  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
    @white_color = Color.new(255, 0, 0)

    @sprite_phases = []
    @current_phase_key = nil
    create_brackground
    create_phases
  end

  def create_brackground
    @sprite_background = Sprite.new
    @sprite_background.bitmap = Bitmap.new("Graphics/System/information_zone")
    @sprite_background.x = @x
    @sprite_background.y = @y
  end

  def terminate
    @sprite_background.dispose
    @sprite_phases.each do |sprite|
      sprite.dispose
    end

  end

  def set_current_phase(key)
    @current_phase_key = key
    create_phases
  end

  def create_phases
    @sprite_phases.each do |sprite|
      sprite.dispose
    end

    sprite_x = @x + 10

    Duel_Phases::PHASES.each do |code, name|
      key = code.keys.first
      phase_name = code.keys.first.to_s.upcase

      sprite = Sprite.new
      sprite.bitmap = Bitmap.new(30, 30)
      if key == @current_phase_key
        if SceneManager.scene.duel_phases.player_1?  
          sprite.bitmap.font.color.set(0, 0, 255)
        else
          sprite.bitmap.font.color.set(255, 0, 0)
        end
      end
      sprite.bitmap.draw_text(0, 0, 30, 30, phase_name)
      sprite.x = sprite_x
      sprite.y = @y

      @sprite_phases << sprite
      sprite_x += 32
    end
  end
end