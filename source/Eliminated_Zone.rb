class Eliminated_Zone < Slot_Base
  def initialize(x, y, board)
    super

    @name = 'Eliminated Zone'
  end
  
  def move_right
    @board.field_zone
  end
  
  def move_left
    @board.battle_field.select_last_monster_slot
  end

  def move_down
    @board.graveyard
  end

  def move_up
    board.opponent_board.field_zone
  end

  def selected_object
    self
  end
end