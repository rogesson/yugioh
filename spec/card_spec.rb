require 'spec_helper.rb'

describe 'Card' do
  describe '#is_monster?' do
    xit 'returns false if is trap or spell' do
      object_pool = nil
      card_attributes = {}
      board = instance_double(Board)

      card = Card.new(object_pool,
        card_attributes,
        0,
        0,
        board
      )

      expect(card.is_monster?).to be true
    end
  end
end