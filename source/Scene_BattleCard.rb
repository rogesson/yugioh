class Scene_BattleCard < Scene_Base
  
  DEBUG_MODE = true

  attr_reader :board_p1, :board_p2, :object_pool, :duel_phases,
  :player_face_sprite, :card_effects 

  def start
    super
    perform_transition
    @card_effects = Card_Effects.new
    @information_window = Information_Window.new
    @card_information_window = Card_Information_Window.new
    @window_card = Window_Card.new
    @window_card.set_handler(:cancel, method(:close_current_window))
    create_battlegroud_sprite
    initialize_objects
    create_player_life_points
    @duel_phases.start

    text = $first_player == :player_1 ? 'Your Turn!' : 'Opponent Turn'
    
    @information_window.set_text(text)
  end

  def transition_speed
    50
  end

  def create_battlegroud_sprite
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new("Graphics/System/background_battle.jpg")
  end

  #[TODO] create a new class to handle that
  def create_player_life_points
    @turn_counter = Sprite.new
    @turn_counter.bitmap = Bitmap.new("Graphics/System/turn_counter")
    @turn_counter.x = 313
    @turn_counter_number = 1
    @turn_counter.bitmap.draw_text(10, 4, 20, 20, @turn_counter_number)
  end

  # Mover para a classe base
  def fill_borders(bitmap, color, line_height)
    width = bitmap.width
    height = bitmap.height

    bitmap.fill_rect(Rect.new(0, 0, width, line_height), color)
    bitmap.fill_rect(Rect.new(0, height - line_height, width, line_height), color)
    bitmap.fill_rect(Rect.new(0, 0, line_height, height), color)
    bitmap.fill_rect(Rect.new(width - line_height, 0, line_height, height), color)
  end

  def bitmap
    @sprite.bitmap
  end

  def initialize_objects
    slot_width =  Slot_Base::SLOT_WIDTH
    slot_height = Slot_Base::SLOT_HEIGHT
    @object_pool = Object_Pool.new

    player_face = Player_Face.new(:player_1, 'yugi', 460, 40)

    @board_p1 = Board.new(:player_1, player_face, 231, 230)
    window_card_action = Window_CardAction.new(@board_p1)
    @board_p1.window_card_action = window_card_action

    @board_p1.add Field_Zone.new(0, 0, @board_p1)
    @board_p1.add Fusion_Zone.new(0, slot_height + 5, @board_p1)

    @board_p1.add Battle_Field.new(:player_1, slot_height, 0, (4 * slot_height) + (4 * 5), 94, @board_p1)

    @board_p1.add Eliminated_Zone.new(185, 0, @board_p1)
    @board_p1.add Graveyard.new(185, slot_height + 5, @board_p1)
    
    @board_p1.add Deck.new(@board_p1)

    @board_p1.add Cursor.new(@board_p1.deck, @board_p1.sprite)
    @board_p1.add Hand.new(:player_1, @board_p1.x, @board_p1.y + 85, 100, 50, @board_p1)
    
    @input_manager = InputManager.new(@board_p1.cursor)

    opponent_face = Player_Face.new(:player_2, 'joey', 150, 40)
    @board_p2 = Board.new(:player_2, opponent_face, 231, 120, true)
    
    @board_p2.window_card_action = window_card_action
    @board_p2.add Field_Zone.new(0, 0, @board_p2)
    @board_p2.add Fusion_Zone.new(0, slot_height + 5, @board_p2)

    @board_p2.add Battle_Field.new(:player_2, slot_height, 0, (4 * slot_height) + (4 * 5), 94, @board_p2)

    @board_p2.add Eliminated_Zone.new(185, 0, @board_p2)
    @board_p2.add Graveyard.new(185, slot_height + 5, @board_p2)
    @board_p2.add Deck.new(@board_p2)

    y = @board_p2.y - 75
    @board_p2.add Hand.new(:player_2, @board_p2.x, y, 100, 50, @board_p1)
    
    @information_zone = Information_Zone.new(231, 181, 205, 30)
    @duel_phases = Duel_Phases.new(@board_p1, @board_p2, @information_zone, $first_player)
  end

  def update
    super
    
    #[TODO] update objects inside board
    @object_pool.update
    @input_manager.update
    @board_p1.cursor.update
    @board_p1.hand.update
    @duel_phases.update
    #[TODO] remove window_card_action from here
    @board_p1.window_card_action.update if @board_p1.window_card_action
    @board_p1.window_phase_action.update if @board_p1.window_phase_action
    @board_p1.update
    @board_p2.update
    @board_p1.battle_field.update
    @board_p2.battle_field.update
    @window_card.update
    if @turn_counter_number != @duel_phases.turn_counter
      @turn_counter.bitmap.clear
      @turn_counter.bitmap = Bitmap.new("Graphics/System/turn_counter")
      @turn_counter.bitmap.draw_text(10, 4, 20, 20, @duel_phases.turn_counter)
      @turn_counter_number = @duel_phases.turn_counter
    end
  end

  #[todo] create test
  def show_card_information(card)
    @card_information_window.show_info(card)
    show_text(card.text)
  end
  
  def close_card_information
    @card_information_window.close
  end

  def show_text(text)
    @information_window.set_text(text)
  end

  def open_phase_actions
    #[TODO] Create phase classes
    show_bp = @duel_phases.turn_counter != 1 && @duel_phases.current_phase == :mp1 
    show_mp2 = @duel_phases.current_phase == :bp
    commands = []
    
    commands << { name: 'Enter Battle Phase.', key: :battle_phase, visible: true } if show_bp
    commands << { name: 'Proceed to Main Phase 2.', key: :mp2, visible: true } if show_mp2
    commands << { name: 'End your turn?', key: :end_turn, visible: true }
 
    @board_p1.window_phase_action = Window_PhaseAction.new(commands, @board_p1)
    
    commands.each do |command|
      @board_p1.window_phase_action
        .set_handler(command[:key], method("command_#{command[:key]}".to_sym))
    end

    @board_p1.window_phase_action.set_handler(:cancel,   method(:close_current_window))
   
    @board_p1.window_phase_action.setup
    @board_p1.cursor.deactivate
  end

  def command_select
    board = @duel_phases.board
    card = board.battle_field.selected_card
    board.battle_field.select_by_state(:waiting_selection)
    card_effect = board.battle_field.selected_card

    Effect.new(card_effect, card).activate
    @board_p1.current_window.close
    @board_p1.cursor.activate
  end

  def command_to_atk
    board = @duel_phases.board
    board.battle_field.selected_card.to_atk
    @board_p1.current_window.close
    @board_p1.cursor.activate
  end

  def command_to_def
    board = @duel_phases.board
    board.battle_field.selected_card.to_def
    @board_p1.current_window.close
    @board_p1.cursor.activate
  end

  def command_look
    @board_p1.current_window.close
    board = @duel_phases.board
    card = board.selected_card
    @window_card.card = card
    @card_information_window.close
    @window_card.open
  end

  def command_set
    board = @duel_phases.board

    board.window_card_action.close if board.window_card_action 
    card = board.hand.set_current_card
    board.battle_field.set_card(card)
  end

  def command_summon
    board = @duel_phases.board

    board.window_card_action.close if board.window_card_action
    card = board.hand.summon_current_card
    board.battle_field.summon_monster(card)
  end

  def command_flip
    board = @duel_phases.board 
    card = board.selected_card
    card.flip
    @board_p1.current_window.close
    @board_p1.cursor.activate
  end

  #[TODO] send this logict to card_command
  def command_activate
    board = @duel_phases.board 
    card = board.selected_card
     
    card_effects.activate(card)

    @board_p1.current_window.close
    @board_p1.cursor.activate
  end

  def command_attack
    board = @duel_phases.board
    board.window_card_action.close if board.window_card_action

    monsters_on_field = board.opponent_board.battle_field.monsters_on_field
    
    monsters_on_field = board.opponent_board.battle_field.face_down_monsters_on_field if monsters_on_field != []
     monsters_on_field.each do |card|
        card.slot.selection_available
        card.change_state(:passive_to_receive_atk)
     end
  
    slot = board.battle_field.selected_slot

    card = slot.card 
    slot.selection_available
    card.change_state(:select_monster)

    board.opponent_board.battle_field.select_by_state(:passive_to_receive_atk)

    if monsters_on_field.empty?
      Monster_Battle.direct_atk(card.atk, card.element, @board_p2)
      card.change_state(:none)
      @board_p1.cursor.activate
    else
      @board_p1.cursor.activate
      @board_p1.cursor.new_current_obj(board.opponent_board.battle_field)
    end
  end

  def command_battle_phase
    @board_p1.window_phase_action.close

    @board_p1.current_window.close
    @duel_phases.set_current_phase(:bp)
    @board_p1.cursor.activate
  end

  def command_mp2
    @board_p1.window_phase_action.close
    
    reset_all_cards_state

    @duel_phases.set_current_phase(:mp2)
    @board_p1.cursor.activate
  end
  
  def command_end_turn
    @board_p1.window_phase_action.close
    @board_p1.hand.reset_card_position
    
    @duel_phases.set_current_phase(:ep)
  end

  def close_current_window
    @window_card.close
    return true if @board_p1.current_window.nil?

    @board_p1.current_window.close
    @board_p1.cursor.activate
  end

  def terminate
    super

    @sprite.dispose

    @board_p1.terminate
    @board_p2.terminate

    @information_zone.terminate
    @information_window.dispose
    @card_information_window.dispose
    @turn_counter.dispose

    @information_zone = nil
    @board_p1 = nil
    @board_p2 = nil
  end

  private

    attr_accessor :window_card

    def reset_all_cards_state
      @board_p1.battle_field.reset_all_cards_state
      @board_p2.battle_field.reset_all_cards_state
    end

    def reset_all_card_position
      @board_p1.battle_field.reset_all_card_position
      @board_p2.battle_field.reset_all_card_position
    end
end
