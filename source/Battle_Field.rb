class Battle_Field
  attr_reader :x, :y, :width, :height, :selected_object, :motion
  attr_accessor :selected_slot
  
  SLOT_AMOUT = 5

  def initialize(player, x, y, width, height, board)    
    @x = x
    @y = y
    @width = width
    @height = height
    @board = board
    
    @monster_slots = []
    @spell_slots   = []
    @selected_slot = nil
    @summoned_this_turn = []
    
    self.window_card_action = board.window_card_action
    # [TODO] Remove this method from initialize and call in another class
    draw
    
    @src_sprite = @board.sprite
  end

  def board_player
    @board.board_player
  end

  def selected_card
    return nil if @selected_slot.nil? || @selected_slot.card.nil?
    
    @selected_slot.card
  end

  #need test
  def selected_object
    @selected_slot
  end

  #need test
  def on_leave
  end

  #need test
  def on_hover
  end

  #need test
  def move_up
    if slot_above == nil 
      if board_player == :player_1
        @board.opponent_board.battle_field.select_last_monster_slot
        @board.opponent_board.battle_field
      else
       @board.opponent_board.battle_field.select_first_monster_slot
       @board.opponent_board.battle_field
      end
    else
      select_object(slot_above)
    end
  end

  # private
  def select_object(obj)
    @selected_slot = obj
    self
  end

  def move_down
    slot = slot_bellow
    if slot
      select_object(slot)
    else
      if @board.hand.empty?
        @board.deck
      else
        @board.hand.select_first_card
      end
    end
  end

  def move_right
    if @selected_slot == @monster_slots.last
      @board.eliminated_zone
    elsif @selected_slot == @spell_slots.last
      @board.graveyard
    else
      select_object(next_slot)
    end
  end

  def move_left
    if @selected_slot == @monster_slots.first
      @board.field_zone
    elsif @selected_slot == @spell_slots.first
      @board.fusion_zone
    else
      select_object(previous_slot)
    end
  end

  def previous_slot
    slots = @selected_slot.is_a?(MonsterSlot) ? @monster_slots : @spell_slots
    slot_index = slots.index(@selected_slot)
    slots[slot_index - 1]
  end

  def next_slot
    slots = @selected_slot.is_a?(MonsterSlot) ? @monster_slots : @spell_slots
    slot_index = slots.index(@selected_slot)
    slots[slot_index + 1]
  end

  def slot_above
    if @selected_slot.is_a?(SpellSlot)
      slot_index = @spell_slots.index(@selected_slot)
      @monster_slots[slot_index]
    else
      nil
    end
  end

  def slot_bellow
    if @selected_slot.is_a?(MonsterSlot)
      slot_index = @monster_slots.index(@selected_slot)
      @spell_slots[slot_index]
    end
  end

  def select_first_spell_slot
    select_object(@spell_slots.first)
  end 

  def select_last_spell_slot
    select_object(@spell_slots.last)
  end

  def select_last_monster_slot
    select_object(@monster_slots.last)
  end

  def select_first_monster_slot
    select_object(@monster_slots.first)
  end

  def select_by_state(state)
    card = (monsters_on_field + spells_on_field).find { |card| card.state == state }
    
    select_object(card.slot) if card
  end

  #[TODO] Adionar imagem do campo atual
  def draw_sprite
    bitmap = Bitmap.new(@width, @height)
    bitmap.fill_rect(0, 0, @width,  @height, Color.new(255, 255, 255))
    @board.sprite.bitmap.blt(@x, y, bitmap, bitmap.rect, 50)
  end
  
  def update
    return if @card.nil? 
    position = @motion.move
    @card.x = position.x
    @card.y = position.y

    if @motion.moved?
      @timer ||= Timer.new(0.2)
      return if @timer.execute?
      if @board.player == :player_1
        @board.cursor.new_current_obj(self)
        @board.cursor.activate
      end

      @card.summon_effect if @card.is_monster? && @card.face == :up
      @card = nil
      @timer = nil
    end
  end

  def next_empty_slot(is_monster)
    slots = is_monster ? @monster_slots : @spell_slots

    slots.find { |slot| slot.card.nil? }
  end

  #[TODO] remove duplication of #set_card
  def summon_monster(card)
    slot = next_empty_slot(true)

    return false if slot.nil?

    @card = card
    #[TODO] create associate_card method
    slot.card = @card
    @card.slot = slot
    select_object(slot)

    @card.to_atk
    @card.change_location(:on_battle_field)
    @summoned_this_turn << @card

    # send this logic to other method
    @position    = Vector2d.new(@card.x, @card.y)
    @destination = Vector2d.new(slot.x, slot.y)

    @motion = Motion.new(@position, @destination, 0.4)

    true
  end

  #[TODO] remove duplication of #summon_card
  def set_card(card)
    slot = next_empty_slot(card.is_monster?)
    
    return false if slot.nil?

    @card = card
    #[TODO] create associate_card method
    slot.card = @card
    card.slot = slot
    select_object(slot)

    @card.change_location(:on_battle_field)
    @position    = Vector2d.new(@card.x, @card.y)

    if @card.is_monster?
      @card.to_def
      @destination = Vector2d.new(slot.x - 4, slot.y + 28)
    else
      @destination = Vector2d.new(slot.x, slot.y)
    end
    @motion = Motion.new(@position, @destination, 0.4)
  end

  def draw
    draw_all_slots
  end

  def summoned_this_turn?
    @summoned_this_turn.include?(selected_card)
  end

  def reset_summoned_monsters_block
    @summoned_this_turn = []
  end

  def perform_ok
    if @selected_slot.card.nil?
      puts "there is not card to perform_ok"
      return
    end
    puts "Card: #{@selected_slot.card} Face: #{@selected_slot.card.face}"

    if @selected_slot.card.state == :passive_to_receive_atk
      #[TODO] CALL Monster_Battle class
      battle
    else 
      window_card_action.show_commands(@selected_slot.card)
    end
  end

  def unselect_all
    @monster_slots.each { |slot| slot.remove_selection }
    @spell_slots.each { |slot| slot.remove_selection }
  end

  def draw_all_slots
    slot_x = @x

    draw_slots_sprite('monster', slot_x, @y)
    draw_slots_sprite('spell', slot_x, @y + Slot_Base::SLOT_HEIGHT + 5)
  end

  #[TODO] receive slots as dependencies
  def draw_slots_sprite(slot_type, x, y)
    SLOT_AMOUT.times do
      if slot_type == 'monster'
        slot = MonsterSlot.new(x, y, @board)
        @monster_slots << slot          
      else
        slot = SpellSlot.new(x, y, @board)
        @spell_slots << slot
      end
      x += Slot_Base::SLOT_WIDTH + 5
    end
  end

  #[TODO] change this method to return card and not slot
  def monsters_on_field
    @monster_slots.map do |slot|
      slot.card if slot.card && slot.card.location == :on_battle_field
    end.compact
  end

  def spells_on_field
    @spell_slots.map do |slot|
      slot.card if slot.card && slot.card.location == :on_battle_field
    end.compact
  end

  def destroy_all_monsters
    monsters_on_field.map(&:send_to_graveyard)
  end

  def face_down_monsters_on_field
    monsters_on_field
  end

  def terminate
    @monster_slots.each { |slot| slot.card.terminate if slot.card }
    @spell_slots.each { |slot| slot.card.terminate if slot.card }
  end

  def reset_all_cards_state
    monsters_on_field.each do |card|
      card.change_state(:none)
      card.slot.remove_selection
    end
  end

  def reset_all_card_position
    monsters_on_field.each do |card|
      card.reset_position
    end
  end

  def battle
    opponent_battle_field.select_by_state(:select_monster)
    striker_card = opponent_battle_field.selected_card
    defender_card = @selected_slot.card
    striker_slot = opponent_battle_field.selected_object

    defender_card.flip if defender_card.face == :down
    Monster_Battle.battle(striker_card, defender_card)

    self.unselect_all
    opponent_battle_field.unselect_all
    return_cursor_to_first_monster_slot
  end

  #[TODO] Remove
  def battle_x(striker_card, defender_card)
    Monster_Battle.battle(striker_card, defender_card)
    self.unselect_all                                                                     
    opponent_battle_field.unselect_all                                                    
  end

  def change_monsters_to_battle_position
    monsters_on_field.each do |card|
      next if card.position == :def
      card.change_state(:ready_to_atk)
    end
  end
 
  private

    attr_accessor :window_card_action

    def return_cursor_to_first_monster_slot
      @board.opponent_board.cursor.new_current_obj(opponent_battle_field.select_first_monster_slot)
    end

    def opponent_battle_field
      @board.opponent_board.battle_field
    end
end
