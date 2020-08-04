class Slot_Base_Physics < Component
  def initialize(game_object)
    @game_object = game_object

    @game_object.x = @game_object.board.x + @game_object.x
    @game_object.y = @game_object.board.y + @game_object.y

    if @game_object.board_player == :player_2
      rotated_cord = rotate_sprite(@game_object.x, @game_object.y)
      @game_object.x = rotated_cord[:x] + 445
      @game_object.y = rotated_cord[:y] + 210
    end
  end

  private

    def rotate_sprite(x, y,  angle = 180)
      center_x = 100
      center_y = 20
      angle = angle * (Math::PI/180)

      rotated_x = Math.cos(angle) * (x - center_x) - Math.sin(angle) * (y-center_y) + center_x;

      rotated_y = Math.sin(angle) * (x - center_x) + Math.cos(angle) * (y - center_y) + center_y;
      
      { x: rotated_x, y: rotated_y }
    end
end