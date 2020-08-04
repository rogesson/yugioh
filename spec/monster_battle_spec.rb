require 'spec_helper.rb'

describe 'Monster_Battle' do
  describe '.battle' do
    context 'when attacking an atk possition monster' do
      it "inflicts dame on opponent if striker atk is more than defender atk" do
        player_board = instance_double(Board, player: :player_1)
        opponent_board = instance_double(Board, player: :player_2)

        striker = instance_double(Card, board: player_board, position: :atk, atk: 1800, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)
        defender = instance_double(Card, board: opponent_board, position: :atk, atk: 1200, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)

        allow(opponent_board).to receive(:receive_damage).once

        expect(Monster_Battle.battle(striker, defender)).to eq(true)
        expect(opponent_board).to have_received(:receive_damage)
          .with(600)
      end

      it "receives damage if defense of opponent is more than striker atk" do
        player_board = instance_double(Board, player: :player_1)
        opponent_board = instance_double(Board, player: :player_2)

        striker = instance_double(Card, board: player_board, position: :atk, atk: 1200, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)
        defender = instance_double(Card, board: opponent_board, position: :atk, atk: 1800, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)

        allow(player_board).to receive(:receive_damage).once

        expect(Monster_Battle.battle(striker, defender)).to eq(true)
        expect(player_board).to have_received(:receive_damage)
          .with(600)
      end

      it "kills both monsters without damage if atk are the same" do
        player_board = instance_double(Board, player: :player_1)
        opponent_board = instance_double(Board, player: :player_2)

        striker = instance_double(Card, board: player_board, position: :atk, atk: 1800, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)
        defender = instance_double(Card, board: opponent_board, position: :atk, atk: 1800, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)

        allow(player_board).to receive(:receive_damage)

        expect(Monster_Battle.battle(striker, defender)).to eq(true)
        expect(player_board).not_to have_received(:receive_damage)
      end

    end

    context 'when attacking a monster in defense position' do
      it "kills defensive monster if striker atk is more than defense" do
        player_board = instance_double(Board, player: :player_1)
        opponent_board = instance_double(Board, player: :player_2)

        striker = instance_double(Card, board: player_board, position: :atk, atk: 2000, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)
        defender = instance_double(Card, board: opponent_board, position: :def, def: 1200, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil, face_up: nil, to_atk: nil)

        allow(opponent_board).to receive(:receive_damage)

        expect(Monster_Battle.battle(striker, defender)).to eq(true)
        expect(opponent_board).not_to have_received(:receive_damage)
      end

      it "receive damage if atk of monster is low than def monster" do
        player_board = instance_double(Board, player: :player_1)
        opponent_board = instance_double(Board, player: :player_2)
        
        striker = instance_double(Card, board: player_board, position: :atk, atk: 1800, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)
        defender = instance_double(Card, board: opponent_board, position: :def, def: 3000, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil, face_up: nil)

        allow(player_board).to receive(:receive_damage).once

        expect(Monster_Battle.battle(striker, defender)).to eq(true)
        expect(player_board).to have_received(:receive_damage)
          .with(1200)
      end
    end
  end

  describe '.direct_atk' do
    it 'attacks opponent board directly' do
      opponent_board = instance_double(Board, player: :player_2)

      card = instance_double(Card, position: :atk, atk: 1800, attribute: "dark", element: 77, atk_effect: nil, dead: nil, change_state: nil)

      allow(opponent_board).to receive(:receive_direct_damage).once

      expect(Monster_Battle.direct_atk(card.atk, card.element, opponent_board))

      expect(opponent_board).to have_received(:receive_direct_damage)
        .with(1800, 77)
    end
  end
end