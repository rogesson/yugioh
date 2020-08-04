class Scene_Lost < Scene_Battle_Result
  def start
    @character_name = "yugi_lost"

    super
    play_gameover_music
  end

  def draw_text
    @background_sprite.bitmap.draw_text(Graphics.width / 2 - 30, 250, 100, 20, "You Lost")
    @background_sprite.bitmap.draw_text(100, 360, 400, 30, "Press C Button to return to the map.")
  end

  def play_gameover_music
    RPG::BGM.stop
    RPG::BGS.stop
    $data_system.gameover_me.play
  end
end
