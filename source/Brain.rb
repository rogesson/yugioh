class Brain
  attr_accessor :current_action
  attr_reader :monster_atk_queue

  def initialize(board_player_1, board_player_2)
    @board_player_1 = board_player_1
    @board_player_2 = board_player_2
    @timer					= Timer.new(1, :brain_timer)
    @monster_atk_queue = []
    @current_action = :initial
  end

  def update
    if current_action == :think
      summon_monster
    end

    if current_action == :bp
      return if not timer.execute?
      return if not moved?

      set_current_phase(:bp)
      @current_action = :change_monsters_to_battle_position
      @timer.reset
      return true
    end

    if current_action == :change_monsters_to_battle_position
      change_monsters_to_battle_position

      return @current_action = :atk_player_monsters
    end

    if current_action == :atk_player_monsters
      return if not timer.execute?
      
      atk_player_monsters

      if @monster_atk_queue.empty?
        @current_action = :ep 
      end

      timer.reset

      return true
    end

    if current_action == :ep
      set_current_phase(:ep)
      @current_action = :initial
    end

    true
  end

  #[TODO] need test
  def atk_player_monsters
    monster = monster_atk_queue.pop
    perform_atk(monster) if monster
  end

	#[TODO] set private and send logic to another method
  def summon_monster
    monsters = monsters_allowed_to_summon
    if monsters.empty?
      if ai_monsters_on_field.empty?
        return @current_action = :ep
      else
        return @current_action = :bp
      end
    end
    
    high_attack_monster_card = monsters.sort_by { |m| m.atk.to_i }.last

    if player_weaker_atk_monster && high_attack_monster_card.atk.to_i < player_weaker_atk_monster.atk.to_i
      set_monster(monsters_allowed_to_summon.first)
      
      return @current_action = :ep
    end

    if player_weaker_atk_monster
      if high_attack_monster_card.atk.to_i >= player_weaker_atk_monster.atk.to_i
        perform_summon(high_attack_monster_card)
      end
    else
      perform_summon(high_attack_monster_card)
    end

    if turn_counter == 1
      @current_action = :ep
    else
      @current_action = :bp
    end
  end

	#[TODO] Refactor
  def perform_atk(offensive_card)
    target_card = nil

    player_monsters = player_monsters_on_field

		#[TODO] Create a new classe to manage cards on both field
    player_monsters_atk_position  = player_monsters.select { |card| card.position == :atk }
    player_monsters_def_position  = player_monsters.select { |card| card.position == :def }
    player_monsters_def_face_down = player_monsters_def_position.select { |card| card.face == :down }

    if player_monsters_atk_position.empty? && player_monsters_def_position.empty?
      direct_atk(offensive_card)
      return true
    end

    player_monsters_atk_position.each do |player_card|
      if player_card.atk.to_i <= offensive_card.atk.to_i
        target_card = player_card
        break
      end
    end

    player_monsters_def_position.each do |player_card|
      player_card.flip if player_card.face == :down
      if player_card.def.to_i <= offensive_card.atk.to_i
        target_card = player_card
        break
      end
    end

    if target_card.nil?
      target_card = player_monsters_def_face_down.first
    end

    if target_card
      battle(offensive_card, target_card)
    else
      false
    end
  end

  #[TODO] check if is used | make private
  def change_monsters_to_battle_position
    ai_monsters_on_field.select do |monster| 
      if monster.position == :atk
        monster.change_state(:ready_to_atk)
        @monster_atk_queue << monster
      end
    end
  end


  #[TODO] Change to Monster_Battle class
  def battle(offensive_card, defensive_card)
    @board_player_2.battle_field.battle_x(offensive_card, defensive_card)
  end

  private

    def turn_counter
      SceneManager.scene.duel_phases.turn_counter
    end

    def moved?
      @board_player_2.battle_field.motion.moved?
    end

		def set_monster(monster)
			hand.select_object(monster)
			SceneManager.scene.command_set
			
			true
		end

		def direct_atk(card)
			@board_player_1.receive_direct_damage(card.atk, card.element)
			card.change_state(:none)
		end
			
		def perform_summon(monster)
			hand.select_object(monster)
			SceneManager.scene.command_summon
		end

		def timer
			@timer
		end
		
    def set_current_phase(phase)
      SceneManager.scene.duel_phases.set_current_phase(phase)

      phase
    end

		def hand
      @board_player_2.hand
    end
	
    def monsters_allowed_to_summon
      hand.monsters_allowed_to_summon
    end

    def ai_monsters_on_field
      @board_player_2.battle_field.monsters_on_field
    end

    def player_monsters_on_field
      player_monsters_on_field.sort_by do |card|
        card.atk.to_i
      end
    end

    def player_weaker_atk_monster
      player_monsters_on_field.last
    end

    def player_monsters_on_field
      @board_player_1.battle_field.monsters_on_field
    end
end
