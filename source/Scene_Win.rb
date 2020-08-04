class Scene_Win < Scene_Battle_Result
  def start
    @character_name = "yugi_win"
    super
    play_win_music
  end

  def draw_text
    @background_sprite.bitmap.draw_text(Graphics.width / 2 - 30, 250, 100, 20, "You Win!")
    @background_sprite.bitmap.draw_text(100, 360, 400, 30, "Press C Button to return to the map.")
  end

  def play_win_music
    RPG::BGM.stop
    RPG::BGS.stop
    $game_system.battle_end_me.play
  end
end
