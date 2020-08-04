class Fusion_Zone < Slot_Base
  def initialize(x, y, board)
    super
    @name = 'Fusion Zone'
  end

  def move_right
    @board.battle_field.select_first_spell_slot
  end

  def move_left
    @board.graveyard
  end

  def move_up
    @board.field_zone
  end

  def move_down
    board.opponent_board.deck
  end

  def selected_object
    self
  end
end