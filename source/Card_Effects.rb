class Card_Effects
  def initialize
    @effects = []
  end

  def activate(card)
    Effect.new(card).activate
    effects << card.id
  end

  def can_activate?(card)
    #[TODO] send all this logic to effect class
    effect = Effect.new(card)
    true
    return false if effects.include?(card.id)
    return false if card.type == "Normal Monster"
    effect.can_activate?(:on_hand)
  end

  private

    attr_reader :effects
end
