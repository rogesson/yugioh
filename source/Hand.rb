class Hand
  attr_accessor :x, :y, :sprite, :selected_card
  attr_reader :cards, :width, :height, :hand_offeset, :board, :player

  def initialize(player, x, y, width, height, board)
    @player = player
    @x = x
    @y = y
    @width = width 
    @height = height
    #[TODO] receive only classes not the whole boardj
    @board = board
    @cards = []
    self.selected_card = nil
    
    self.window_card_action = board.window_card_action
    @summoned_monsters = 0
    @hand_offeset = @board.x + Card::CARD_HEIGHT + 20
  end

  def board_player
    board.board_player
  end

  def text
    selected_card.text
  end

  def on_hover
    hide_cursor

    if selected_card && player == :player_1
      show_card_information
    else
      close_card_information
    end

    true
  end

  def on_leave
    board.cursor.show
    reset_card_position
  end

  def select_object(obj)
    reset_card_position
    obj.y -= 4
    obj.z = 301

    @sprite = obj.sprite
    self.selected_card = obj

    self
  end

  def reset_card_position
    if selected_card 
      self.selected_card.y = @y
      self.selected_card.z = 300
    end
  end

  def empty?
    @cards.empty?
  end

  def select_first_card
    select_object(@cards.first)
  end

  def move_up
    reset_card_position
    self.selected_card = nil
    board.battle_field.select_first_spell_slot
  end

  def move_down
    reset_card_position
    board.opponent_board.deck
  end

  def move_right
    card = next_card
    if card
      select_object(card)
    else
      board.deck
    end
  end

  def move_left
    card = previous_card
    if card
      select_object(card)
    else
      board.deck
    end
  end

  def next_card
    card_index = @cards.index(selected_card)
    card = @cards[card_index + 1]

    card = @cards.first if card.nil?
    card
  end

  def previous_card
    card_index = @cards.index(selected_card)
    card = @cards[card_index - 1]

    card = @cards.last if card.nil?
    card
  end

  def last_card
    return nil if empty?

    @cards.last
  end

  def perform_ok
    window_card_action.show_commands(selected_card)
  end

  def update
    return if selected_card.nil?
    selected_card.update
  end

  def add(card)
    card.change_location(:on_hand)
    @cards << card
    reorganize
  end

  def monsters_allowed_to_summon
    monsters.map do |monster|
      #[TODO] select card only if monster can be summoned
      select_object(monster)
      reset_card_position
      monster if can_summon?
    end.compact
  end

  #[TODO] combine this method with set_current_card
  def summon_current_card
    reset_card_position
    card = selected_card
    card.face_up
    @cards.delete(card)
    self.selected_card = nil
    increment_summons
    reorganize

    card
  end

  def set_current_card
    reset_card_position
    card = selected_card
    card.face_down
    increment_summons if card.is_monster?
    @cards.delete(card)
    self.selected_card = nil
    reorganize

    card
  end

  def reorganize
    @hand_offeset = @board.x + Card::CARD_HEIGHT + 20

    @cards.each do |card|
      card.x = @hand_offeset
      if @cards.size > 6 
        @hand_offeset += (100 / @cards.size)
      else
        @hand_offeset += (Card::CARD_HEIGHT / 2)
      end
      card.y = @y
    end
  end

  def terminate
    @cards.each { |card| card.terminate }
    @cards = []
  end

  def can_summon?
    card = selected_card

    return false if not card.is_monster?
    return false if card.level.to_i > 4
    return false if first_summon?
    return false if battle_field.next_empty_slot(card.is_monster?).nil?
    
    true
  end

  def can_set?
    card = selected_card
    return false if not card.is_monster?
    return false if card.level.to_i > 4
    return false if first_summon?
    
    true
  end

  def reset_summons
    @summoned_monsters = 0
  end

  private
    
    attr_accessor :window_card_action

    def monsters
      cards.select { |card| card.is_monster? }
    end

    def increment_summons
      @summoned_monsters += 1
    end

    def first_summon?
      @summoned_monsters > 0
    end

    def has_empty_slot?(card_type)
      battle_field.next_empty_slot(card_type)
    end

    def battle_field
      board.battle_field
    end

    #[TODO] chance this method to board class
    def hide_cursor
      board.cursor.hide
    end

    #[TODO] Doest call SceneManager
    def show_card_information
      SceneManager.scene.show_card_information(selected_card)
    end

    #[TODO] Doest call SceneManager
    def close_card_information
      SceneManager.scene.close_card_information
    end
end
