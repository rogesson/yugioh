class Slot_Base_Graphics < Component
  LINE_HEIGHT = 2

  def initialize(game_object, board)
    super()

    @player = board.player
    @game_object = game_object
  end

  def draw
    @bitmap = Bitmap.new("Graphics/System/#{slot_graph}")
    SceneManager.scene.bitmap.blt(@game_object.x, @game_object.y, @bitmap, @bitmap.rect, 190)
    @bitmap.dispose
  end

  def draw_red_color
    #@bitmap = Bitmap.new(@game_object.width, @game_object.height)
    #fill_borders(@bitmap, Color.new(255, 0, 0), LINE_HEIGHT)
    #SceneManager.scene.bitmap.blt(@game_object.x, @game_object.y, @bitmap, @bitmap.rect, 200)
    #@bitmap.dispose
  end

  def dispose
    @bitmap.dispose if @bitmap
  end

  private

    def fill_borders(bitmap, color, line_height)
      width = bitmap.width
      height = bitmap.height

      bitmap.fill_rect(Rect.new(0, 0, width, line_height), color)
      bitmap.fill_rect(Rect.new(0, height - line_height, width, line_height), color)
      bitmap.fill_rect(Rect.new(0, 0, line_height, height), color)
      bitmap.fill_rect(Rect.new(width - line_height, 0, line_height, height), color)
    end


    def slot_graph
      @player == :player_1 ? 'player_field_slot' : 'enemy_field_slot'
    end
end