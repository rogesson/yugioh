class Scene_Battle_Result < Scene_Base
  def start
    super
    create_background
    create_character
    create_shadow_box
    draw_text
  end

  def terminate
    super
    dispose_background
  end
 
  def update
    super

    goto_map if Input.trigger?(:C)
  end
 
  def perform_transition
    Graphics.transition(fadein_speed)
  end
 
  def play_win_music
    RPG::BGM.stop
    RPG::BGS.stop
    $game_system.battle_end_me.play
  end
  
  def fadeout_frozen_graphics
    Graphics.transition(fadeout_speed)
    Graphics.freeze
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Cache.system("background_battle.jpg")
  end

  def create_character
    character = Cache.battler("#{@character_name}.png", 0)
    @background_sprite.bitmap.blt(210, -4, character, character.rect)
  end

  def create_shadow_box
    box_shadow_bitmap = Bitmap.new(545, 155)
    box_shadow_bitmap.fill_rect(Rect.new(0, 0, box_shadow_bitmap.width, box_shadow_bitmap.height), Color.new(0,0,0))
    @background_sprite.bitmap.blt(0, 240, box_shadow_bitmap, box_shadow_bitmap.rect, 210)
  end

  def dispose_background
    @background_sprite.bitmap.dispose
    @background_sprite.dispose
  end
  
  def fadeout_speed
    60
  end
  
  def fadein_speed
    120
  end
  
  def goto_map
    fadeout_all
    SceneManager.goto(Scene_Map)
  end
end
