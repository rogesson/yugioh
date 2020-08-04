describe 'Scene_BattleStart' do
  describe '#start' do
    it 'returns true when all is created with success' do
      scene_battle_start = Scene_BattleStart.new

      window_first_player = instance_double(Window_FirstPlayer, close: true,
      set_handler: true, open?: false)

      allow(Window_FirstPlayer).to receive(:new)
        .and_return(window_first_player)

      expect(scene_battle_start.start).to eq(true)
    end
  end

  describe '#update' do
    context 'update input' do
      it 'sends cards to the cener because there is not card in center' do
        scene_battle_start = Scene_BattleStart.new

        card = {
          player: 1,
          name: :scissors,
          type: { index: 0 },
          original_position: { x: 1, y: 1 },
          sprite: Sprite.new
        }

        card[:sprite].x = 1
        card[:sprite].y = 1

        window_first_player = instance_double(Window_FirstPlayer, close: true,
        set_handler: true, open?: false)
      
        allow(scene_battle_start).to receive(:window_first_player)
          .and_return(window_first_player)

        allow(Input).to receive(:trigger?)
          .with(:C)
          .and_return(true)

        allow(scene_battle_start).to receive(:card_in_center)
          .and_return(false)

        allow(scene_battle_start).to receive(:player_selected_card)
          .and_return(card)

        allow(scene_battle_start).to receive(:opponent_cards)
          .and_return([card])

        expect(scene_battle_start.update).to be true
      end

      it 'sends cards to the original position because they are in the center' do
        scene_battle_start = Scene_BattleStart.new

        window_first_player = instance_double(Window_FirstPlayer, open?: false, open: true)

        allow(window_first_player).to receive(:commands=)
          .with([{:key=>:first_to_go, :name=>"FIRST TO GO", :visible=>true},
                 {:key=>:second_to_go, :name=>"SECOND TO GO", :visible=>true}])

        card = {
          player: 1,
          name: :scissors,
          type: { index: 0 },
          original_position: { x: 1, y: 1 },
          sprite: Sprite.new
        }

        card[:sprite].x = 1
        card[:sprite].y = 1

        allow(Input).to receive(:trigger?)
          .with(:C)
          .and_return(true)

        allow(scene_battle_start).to receive(:card_in_center)
          .and_return(true)

        allow(scene_battle_start).to receive(:player_selected_card)
          .and_return(card)

        allow(scene_battle_start).to receive(:opponent_selected_card)
          .and_return(card)

        allow(scene_battle_start).to receive(:battle_result)
          .and_return(true)

        allow(scene_battle_start).to receive(:window_first_player)
          .and_return(window_first_player)

        scene_battle_start.send(:create_info_box)

        expect(scene_battle_start.update).to be true
      end
    end
  end

  describe '#calculate_results' do
    it 'returns draw when type is the same' do
      scene_battle_start = Scene_BattleStart.new
      player_card   = { name: :scissors }
      opponent_card = { name: :scissors }

      expect( 
        scene_battle_start.send(:calculate_results, player_card, opponent_card)
      ).to eq(:draw)
    end
    
    context 'scissors' do
      it 'returns win when opponent is paper' do
        scene_battle_start = Scene_BattleStart.new
        player_card   = { name: :scissors }
        opponent_card = { name: :paper }

        expect( 
          scene_battle_start.send(:calculate_results, player_card, opponent_card)
        ).to eq(:win)
      end

      it 'returns lose when opponent is rock' do
        scene_battle_start = Scene_BattleStart.new
        player_card   = { name: :scissors }
        opponent_card = { name: :rock }

        expect( 
          scene_battle_start.send(:calculate_results, player_card, opponent_card)
        ).to eq(:lose)
      end
    end

    context 'paper' do
      it 'returns win when opponent is rock' do
        scene_battle_start = Scene_BattleStart.new
        player_card   = { name: :paper }
        opponent_card = { name: :rock }

        expect( 
          scene_battle_start.send(:calculate_results, player_card, opponent_card)
        ).to eq(:win)
      end

      it 'returns lose when opponent is scissors' do
        scene_battle_start = Scene_BattleStart.new
        player_card   = { name: :paper }
        opponent_card = { name: :scissors }

        expect( 
          scene_battle_start.send(:calculate_results, player_card, opponent_card)
        ).to eq(:lose)
      end
    end

     context 'rock' do
      it 'returns win when opponent is scissors' do
        scene_battle_start = Scene_BattleStart.new
        player_card   = { name: :rock }
        opponent_card = { name: :scissors }

        expect( 
          scene_battle_start.send(:calculate_results, player_card, opponent_card)
        ).to eq(:win)
      end

      it 'returns lose when opponent is paper' do
        scene_battle_start = Scene_BattleStart.new
        player_card   = { name: :rock }
        opponent_card = { name: :paper }

        expect( 
          scene_battle_start.send(:calculate_results, player_card, opponent_card)
        ).to eq(:lose)
      end
    end
  end
end
