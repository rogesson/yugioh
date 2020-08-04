class Duel_Phases

  attr_reader :board, :turn_counter, :current_phase

  PHASES = [
    { dp: 'Draw Phase'    },
    { sp: 'Standby Phase' },
    { mp1: 'Main Phase 1' },
    { bp: 'Battle Phase'  },
    { mp2: 'Main Phase 2' },
    { ep: 'End Phase'     }
  ]
  
  def initialize(board_p1, board_p2, information_zone, first_player)
    @boards = [board_p1, board_p2]
    @information_zone = information_zone
    @board = set_player(first_player)
    @current_phase = nil
    @executed = false
    @timer =  Timer.new(0.6, "duel_phase")
    @turn_counter = 1
    @brain = Brain.new(board_p1, board_p2)
  end

  def set_player(player)
    @board = player == :player_1 ? @boards[0] : @boards[1]
  end

  def player_1?
    @board.player == :player_1
  end

  def start
    set_current_phase(:dp)
    draw_count = @turn_counter == 1 ? 6 : 1

    #[TODO] Call board method set_draw_count
    deck.set_draw_count(draw_count)

    #[TODO] Call board method reset_summons
    hand.reset_summons

    true
  end

  def set_current_phase(phase)
    @timer.reset
    @executed = false
    @current_phase = phase
    @information_zone.set_current_phase(phase)
  end

  def update
    @brain.update
    return if not timer.execute?

    #[TODO] remove execution of each update (call class#method) just one time
    if execute?(:dp)
      if deck.draw_count == 0
        set_current_phase(:sp)
      else 
        #[TODO] Move this if to #perform_draw
        deck.perform_draw if deck.drawing == false
      end

      return true #[TODO] remove this return
    end

    if execute?(:sp)
      set_current_phase(:mp1)

      return true #[TODO] remove this return
    end

    if execute?(:mp1)
      if player_1?
        #[TODO] remove cursor and hand method and create new method on board class
        cursor.activate
        cursor.new_current_obj(hand.select_first_card)
      else
        ai_play
      end
      
      #[TODO] verify if is needed
      @executed = true
      return true #[TODO] remove this return
    end

    if execute?(:bp)
      if player_1?
        battle_field.change_monsters_to_battle_position
        #[TODO] verify if is needed
        @executed = true

        return true #[TODO] remove this return
      else

        @executed = true

        return true #[TODO] remove this return
      end
    end

    if execute?(:ep)
      #[TODO] DUPLICADO DA SCENE_BATTLE_CARD#command_end_turn ???
      board.reset_cards_position
      
      player_1? ? set_player(:player_2) : set_player(:player_1)
        
      start
      increment_turn_counter
    end
  end

  private

    attr_reader :timer

    def execute?(phase)
      return false if @executed

      @current_phase == phase
    end

    def increment_turn_counter
      @turn_counter += 1
    end

    #[TODO] remove this method and create new method on board class
    def cursor
      @board.cursor
    end

    #[TODO] remove this method and create new method on board class
    def hand
      @board.hand
    end

    #[TODO] remove this method and create new method on board class
    def deck
      @board.deck
    end

    #[TODO] remove this method and create new method on board class
    def battle_field
      @board.battle_field
    end

    def ai_play
      @brain.current_action = :think
    end
end
