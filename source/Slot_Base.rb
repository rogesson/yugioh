class Slot_Base < Game_Object
  SLOT_WIDTH = 25
  SLOT_HEIGHT = 32
  LINE_HEIGHT = 2

  attr_accessor :x, :y

  def initialize(x, y, board)
    super(SceneManager.scene.object_pool)
    @cards = []
    @board = board
    @x = x
    @y = y

    @phisycs = Slot_Base_Physics.new(self)
    @graphics = Slot_Base_Graphics.new(self, board)
  
    draw #[TODO] remover draw
  end

  def draw
    @graphics.draw
  end

  def width
    SLOT_WIDTH
  end

  def height
    SLOT_HEIGHT
  end

  def bright
    @graphics.draw_red_color
  end

  #[TODO] create test
  def on_hover
    card = @cards.last || @card 

    if card.nil? || self.is_a?(Deck)
      show_text(@name)

      return
    end

    if card && board.player == :player_2 && card.face != :up
      show_text(@name)

      return
    end

    SceneManager.scene.show_card_information(card)
  end

  def on_leave
    #@graphics.draw
  end

  def selection_available
    #@graphics.draw_red_color
  end

  def remove_selection
    #@graphics.draw
  end

  def board_player
    @board.board_player
  end

  def board
    @board
  end

  def terminate
    @graphics.dispose
  end

  private

    def show_text(text)
      SceneManager.scene.show_text(text)
      SceneManager.scene.close_card_information
    end
end