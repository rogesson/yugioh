class Card_Commands < Component
  def initialize(game_object)
    super

    @game_object  = game_object
  end

  def list
    @command_list = []
    case @game_object.location
    when :on_hand
      hand_commands
    when :on_battle_field
      battle_field_commands
    else
      puts "unknown card location: #{@game_object.location}"
    end

    @command_list
  end

  private

    def hand_commands
      return true if @game_object.board.player == :player_2

      @command_list << { name: 'View', key: :look, visible: true } 

      if can_activate?
        @command_list << { name: 'Activate', key: :activate, visible: true }
      end

      if can_summon?
        @command_list << { name: 'Summon', key: :summon, visible: true } 
      end

      if can_set?
        @command_list << { name: 'Set', key: :set, visible: true } 
      end
    end

    def battle_field_commands
      @command_list << { name: 'Look', key: :look, visible: true }
      
      if @game_object.state == :passive_to_selection
        @command_list << { name: 'Select', key: :select, visible: true }
      end

      if @game_object.board.player == :player_2
        return true
      end

      if @game_object.face == :down && @game_object.is_monster?
        @command_list << { name: 'Flip', key: :flip, visible: true }
      end

      if can_activate?
        @command_list << { name: 'Activate', key: :activate, visible: true }
      end
      
      if @game_object.is_monster?
        if @game_object.state == :ready_to_atk
          @command_list << { name: 'Attack', key: :attack, visible: true } 
        end

        if !summoned_this_turn? && @game_object.can_change_to_atk?
          @command_list << { name: 'To Atk', key: :to_atk, visible: true }
        end

        if !summoned_this_turn? && @game_object.can_change_to_def?
          @command_list << { name: 'To Def', key: :to_def, visible: true }
        end
      end
    end

    def can_summon?
      SceneManager.scene.duel_phases.board.hand.can_summon?
    end

    def summoned_this_turn?
      SceneManager.scene.duel_phases.board.battle_field.summoned_this_turn?
    end

    def can_activate?
      SceneManager.scene.card_effects.can_activate?(@game_object)
    end

    def can_set?
      if @game_object.is_monster?
        can_summon?
      else
        ['Trap Card',
        'Spell Card'].include?(@game_object.type)
      end
    end
end
