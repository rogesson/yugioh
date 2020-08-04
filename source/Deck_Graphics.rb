class Deck_Graphics < Component
  MOVE_CARD_SPRITE_SHEET = "Graphics/Pictures/card_moviments.png"

  def initialize(game_object)
    super

    @game_object = game_object
  end

  def draw
    bitmap = Bitmap.new(MOVE_CARD_SPRITE_SHEET)

    SceneManager.scene.bitmap.blt(@game_object.x, @game_object.y, bitmap, Rect.new(388, 0, 23.8, 31))
    SceneManager.scene.bitmap.blt(@game_object.x + 1 , @game_object.y - 1, bitmap, Rect.new(388, 0, 23.8, 31))
    SceneManager.scene.bitmap.blt(@game_object.x + 2 , @game_object.y - 2, bitmap, Rect.new(388, 0, 23.8, 31))
  end
end