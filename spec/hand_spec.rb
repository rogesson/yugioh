require 'spec_helper.rb'

describe 'Hand' do
  describe '#can_summon?' do
    it 'returns true if this card can be summoned' do
      board = instance_double(Board, x: 0, board_player: :player_1)
      card = instance_double(Card, is_monster?: true, level: 4)
      battle_field = instance_double(Battle_Field)

      hand = Hand.new(:player_1, 0, 0, 100, 100, board)

      allow(battle_field).to receive(:next_empty_slot)
        .with(true)
        .and_return(anything)

      allow(hand).to receive(:battle_field)
        .and_return(battle_field)
      allow(hand).to receive(:selected_card)
        .and_return(card)
      expect(hand.can_summon?).to eq(true)
    end
  end

  describe '#monsters_allowed_to_summon' do
    it 'returns monsters allowed to be summoned' do
      board = instance_double(Board, x: 0, board_player: :player_1)
      hand = Hand.new(:player_1, 0, 0, 100, 100, board)

      allowed_monster = instance_double(Card, is_monster?: true, level: 4, can_summon?: true)
      
      allow(hand).to receive(:monsters)
        .and_return([allowed_monster])

      allow(hand).to receive(:select_object)
        .with(allowed_monster)
        .and_return(hand)

      allow(hand).to receive(:can_summon?)
        .and_return(true)

      expect(hand.monsters_allowed_to_summon)
        .to eq([allowed_monster])
    end
  end

  describe '#on_hover' do
    context 'when is player_1' do
      it 'shows card information' do
        board = instance_double(Board, x: 0)
        card = instance_double(Card)
        hand = Hand.new(:player_1, 0, 0, 0, 0, board)

        allow(hand).to receive(:hide_cursor)
          .and_return(true)

        allow(hand).to receive(:selected_card)
          .and_return(card)

        allow(hand).to receive(:show_card_information)
          .once

        expect(hand.on_hover).to be true
        expect(hand).to have_received(:show_card_information)
      end
    end

    context 'when is player_2' do
      it 'closes card information' do
        board = instance_double(Board, x: 0)
        card = instance_double(Card)
        hand = Hand.new(:player_2, 0, 0, 0, 0, board)

        allow(hand).to receive(:hide_cursor)
          .and_return(true)

        allow(hand).to receive(:selected_card)
          .and_return(card)

        allow(hand).to receive(:close_card_information)
          .once

        expect(hand.on_hover).to be true
        expect(hand).to have_received(:close_card_information)
      end
    end

    context 'when there is not card' do
      it 'closes card information' do
        board = instance_double(Board, x: 0)
        hand = Hand.new(:player_2, 0, 0, 0, 0, board)

        allow(hand).to receive(:hide_cursor)
          .and_return(true)

        allow(hand).to receive(:selected_card)
          .and_return(nil)

        allow(hand).to receive(:close_card_information)
          .once

        expect(hand.on_hover).to be true
        expect(hand).to have_received(:close_card_information)
      end
    end
  end
end