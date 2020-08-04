class Card_Physics < Component
  def initialize(game_object)
    @game_object = game_object
    @face = nil
  end

  def face
    @face
  end

  def face_up
    @face = :up
  end

  def face_down
    @face = :down
  end

  def to_atk
    @game_object.x += 4
    @game_object.y -= 28

    face_up
  end

  def to_def
    @game_object.x -= 4
    @game_object.y += 28
  end
end