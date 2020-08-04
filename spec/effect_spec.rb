require 'spec_helper.rb'

describe 'Effect' do
  describe '#activate' do
    it 'activates effect of a given card' do
      board_player_1 = instance_double(Board, player: :player_1, x: 0, y: 0)
      board_player_2 = instance_double(Board, player: :player_2, x: 0, y: 0)

      allow(board_player_1).to receive(:opponent_board)
        .and_return(board_player_2)

      card = instance_double(Card, atk: 400, id: 98049915, board: board_player_1, element: 1)

      effect = Effect.new(card)
      allow(effect).to receive(:effect_98049915).once

      expect(effect.activate).to be true
      expect(effect).to have_received(:effect_98049915)
    end
  end
end
