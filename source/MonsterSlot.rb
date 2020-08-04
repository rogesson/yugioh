class MonsterSlot < Slot_Base 
  
  attr_accessor :card
  
  def initialize(x, y, board)
    super
    @name = 'Monster Slot'
    @card = nil
  end
end