class Graveyard < Slot_Base
  def initialize(x, y, board)
    super
    @motions = []
    @name = 'Graveyard'
  end
  
  def move_up
    @board.eliminated_zone
  end

  def move_down
    @board.deck
  end

  def move_left
    @board.battle_field.select_last_spell_slot
  end

  def move_right
    @board.fusion_zone
  end

  def destroy_card(card)
    @cards << card
    @position    = Vector2d.new(card.x, card.y)
    @destination = Vector2d.new(@x, @y)

    motion = Motion.new(@position, @destination, 0.4)
    motion.object = card
    @motions << motion
  end

  def update
    @motions.each do |motion|
      position = motion.move
      motion.object.x = position.x
      motion.object.y = position.y

      if motion.moved?
        motion.execute
        @motions.delete(motion)
      end
    end
  end

  def selected_object
    self
  end

  def terminate
    @cards.each { |card| card.terminate }
  end
end