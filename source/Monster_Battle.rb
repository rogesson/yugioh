class Monster_Battle
  def self.battle(striker_card, defender_card)
    if defender_card.position == :atk
      atk_offensive_monster(striker_card, defender_card)
    else
      atk_defensive_monster(striker_card, defender_card)
    end
    
    striker_card.change_state(:none)
    
    true
  end

  def self.direct_atk(atk, element, board_target)
    board_target.receive_direct_damage(atk, element)
  end

  private

    def self.atk_offensive_monster(striker_card, defender_card)
      if striker_card.atk > defender_card.atk
        defender_card.atk_effect(striker_card.element)
        defender_card.dead
        defender_card.board.receive_damage(striker_card.atk - defender_card.atk)

        return true
      end

      if striker_card.atk < defender_card.atk
        striker_card.atk_effect(defender_card.element)
        striker_card.dead
        striker_card.board.receive_damage(defender_card.atk - striker_card.atk)

        return true
      end

      if striker_card.atk == defender_card.atk
        striker_card.atk_effect(defender_card.element)
        defender_card.atk_effect(striker_card.element)
        defender_card.dead
        striker_card.dead

        return true
      end
    end

    def self.atk_defensive_monster(striker_card, defender_card)
      defender_card.face_up

      if striker_card.atk > defender_card.def
        defender_card.atk_effect(striker_card.element)
        defender_card.to_atk
        defender_card.dead
      end

      if striker_card.atk < defender_card.def
        striker_card.atk_effect(defender_card.element)
        striker_card.board.receive_damage(defender_card.def - striker_card.atk)
      end
    end
end
