class SpellSlot < Slot_Base

  attr_accessor :card

  def initialize(x, y, board)
    super
    @name = 'Spell Slot'
    @card = nil
    @board = board
  end
end