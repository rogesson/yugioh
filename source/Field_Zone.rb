class Field_Zone < Slot_Base
  def initialize(x, y, board)
    super

    @name = 'Field Zone'
  end

  def move_right
    @board.battle_field.select_first_monster_slot
  end

  def move_left
    @board.eliminated_zone
  end

  def move_down
    @board.fusion_zone
  end

  def move_up
    board.opponent_board.eliminated_zone
  end

  def selected_object
    self
  end
end