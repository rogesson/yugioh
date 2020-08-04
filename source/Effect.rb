class Effect
  attr_reader :executed

  def initialize(card, target = nil)
    @card = card
    @board = card.board
    @opponent_board = @board.opponent_board
    @conditions = card.conditions
    @executed = false
    @target = target
  end

  def activate
    card.face_up unless card.is_monster?
    if card.location == :on_hand
      #[todo] call_set_card into set_current_card
      @board.hand.set_current_card
      @board.battle_field.set_card(card)
      card.face_up
    end

    effect_37120512

    #send("effect_#{@card.id}")
    true
  end

  def can_activate?(condition)
    puts "Checking #{condition} in #{conditions}"
    #return false unless conditions.include?(condition)

    puts "Checking condition of #{@card.id}"
    condition_37120512
    #send("condition_#{@card.id}")
  end

  private

    attr_accessor :card, :conditions, :board, :target

    attr_writer :executed
    
    def effect_37120512
      #Sword of Dark Destruction
      #Equip only to a DARK monster. It gains 400 ATK and loses 200 DEF.

      if target
        target.atk += 400
        target.def += 200
        animation = Animation.find(43)
        target.sprite.start_animation(animation)

        target.change_state(:none)
        card.change_state(:none)
      else
        monsters = @board.battle_field.monsters_on_field
        card.change_state(:waiting_selection)
        monsters.each do |monster|
          next if monster.face == :down 
          next if monster.attribute != "DARK"
          monster.change_state(:passive_to_selection)
        end
      end
    end

    def condition_37120512
      monsters = @board.battle_field.monsters_on_field
      attributes = monsters.map { |monster| monster.attribute }
      
      puts "attributes: #{attributes}" 
      attributes.include?("DARK")
    end

    def effect_84257640
      @board.increase_life_points(1000)
      card.send_to_graveyard
    end
    
    #Mystic Lamp
    def effect_98049915
      Monster_Battle.direct_atk(card.atk, card.element, @opponent_board)
    end

    #Time Wizard
    def effect_71625222
      if rand(2) == 0
        @opponent_board.battle_field.destroy_all_monsters
      else
        monsters = @board.battle_field.monsters_on_field

        unless monsters.empty?
          total_atk = monsters.map do |monster|
            monster.atk
          end.inject(:+) / 2

          @board.receive_direct_damage(total_atk, monsters.first.element)
          @board.battle_field.destroy_all_monsters
        end
      end    
    end
end
