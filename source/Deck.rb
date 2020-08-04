class Deck < Slot_Base
  attr_accessor :x, :y, :cards, :draw_count
  attr_reader :drawing

  MOVE_CARD_SPRITE_SHEET = "Graphics/Pictures/card_moviments.png"
  DRAW_DELAY = 30

  def initialize(board)
    @x = 185
    @y = 75
    
    @board = board
    super(@x, @y, @board)
    create_cards
    @timer = Timer.new(2)
    @graphycs = Deck_Graphics.new(self)

    @draw_count = 0

    @graphycs.draw
    @name = "Deck #{@cards.size}"
    @position    = Vector2d.new(@x, @y)
    @drawing   = false
  end

  def perform_ok
    @board.perfom_draw
  end

  def move_up
    @board.graveyard
  end

  def move_left
    @board.battle_field.select_last_spell_slot
  end

  def move_down
    board.opponent_board.fusion_zone
  end

  def set_draw_count(count)
    @draw_count = count
  end

  def perform_draw
    @destination = Vector2d.new(@board.hand.hand_offeset, @board.hand.y)
    @motion = Motion.new(@position, @destination, 1)
    @card = @cards.pop
    @card.face_up
    @card.show

    @card.face_down if @board.player == :player_2
    @drawing = true
  end

  def update
    if @drawing && @draw_count > 0
      position = @motion.move
      @card.x = position.x
      @card.y = position.y

      if @motion.moved?
        @draw_count -= 1
        @board.hand.add(@card)
        @drawing = false
      end
    end
  end

  def create_cards
    if @board.board_player == :player_1
      cards_monster = Card_List::CARD_MONSTERS_P1
    else
      cards_monster = Card_List::CARD_MONSTERS_P2
    end

    @cards = []
    40.times do |card_attributes|
      object_pool = SceneManager.scene.object_pool
      card_index = rand(cards_monster.size)

      card = Card.new(object_pool, cards_monster[card_index],
                         @x,
                         @y,
                         @board)
      
      @cards << card
    end
  end

  def selected_object
    self
  end
end
