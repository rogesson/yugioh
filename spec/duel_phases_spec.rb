require 'spec_helper.rb'

describe 'Duel_Phases' do
  describe 'set_player' do
    it 'defines that is time of player_1 to play' do
      duel_phases = initialize_described_class

      duel_phases.set_player(:player_1)

      expect(duel_phases.board.player)
        .to eq(:player_1)
    end
  end

  describe 'player_1?' do
    it 'checks if current turn is of player 1' do
      duel_phases = initialize_described_class

      expect(duel_phases.player_1?)
        .to be true

      duel_phases.set_player(:player_2)

      expect(duel_phases.player_1?)
        .to be false
    end
  end

  describe 'start' do
    it 'starts the turn of player' do
      board_1 = instance_double(Board)

      deck = instance_double(Deck, set_draw_count: true)
      hand = instance_double(Hand, reset_summons: true)

      allow(board_1).to receive(:hand)
        .and_return(hand)

      duel_phases = initialize_described_class(board_1: board_1)

      allow(duel_phases).to receive(:hand)
        .and_return(hand)

      allow(duel_phases).to receive(:deck)
        .and_return(deck)

      allow(duel_phases).to receive(:set_current_phase)
        .with(:dp)

      expect(duel_phases.start).to be true
    end
  end

  describe 'set_current_phase' do
    it 'sets the current phase of player turn' do
      duel_phases = initialize_described_class

      duel_phases.set_current_phase(:bp)

      expect(duel_phases.current_phase)
        .to eq(:bp)
    end
  end

  describe 'update' do
    context 'when the current phase is dp (Draw Please)' do
      it 'sets current phase to SP (Standby Please) if draw count is zero' do
        board_1 = instance_double(Board)
        timer   = instance_double(Timer, execute?: true)

        deck = instance_double(Deck, draw_count: 0)

        duel_phases = initialize_described_class(board_1: board_1)

        allow(duel_phases).to receive(:deck)
          .and_return(deck)

        allow(duel_phases).to receive(:timer)
          .and_return(timer)

        duel_phases.set_current_phase(:dp)

        duel_phases.update

        expect(duel_phases.current_phase).to eq(:sp)
      end

      it 'draws one card if draw count is non-zero and continues at the same phase' do
        board_1 = instance_double(Board)
        timer   = instance_double(Timer, execute?: true)

        deck = instance_double(Deck, draw_count: 1, 
          drawing: false, 
          perform_draw: true)

        duel_phases = initialize_described_class(board_1: board_1)

        allow(duel_phases).to receive(:deck)
          .and_return(deck)

        allow(duel_phases).to receive(:timer)
          .and_return(timer)

        duel_phases.set_current_phase(:dp)

        duel_phases.update

        expect(duel_phases.current_phase).to eq(:dp)
      end
    end

    context 'when the current phase is sp (Standby Please)' do
      it 'sets mp1 (Main Phase 1) as current phase' do
        duel_phases = initialize_described_class
        timer = instance_double(Timer, execute?: true)

        allow(duel_phases).to receive(:timer)
          .and_return(timer)

        duel_phases.set_current_phase(:sp)

        duel_phases.update

        expect(duel_phases.current_phase).to eq(:mp1)
      end
    end

    context 'when the current phase is mp1 (Main Phase 1)' do
      it 'actives the cursor if the current player is 1' do
        board_1 = instance_double(Board)
        timer   = instance_double(Timer, execute?: true)
        cursor  = instance_double(Cursor, activate: true)
        hand    = instance_double(Hand, select_first_card: true)

        duel_phases = initialize_described_class(board_1: board_1)

        allow(duel_phases).to receive(:timer)
          .and_return(timer)
        
        allow(duel_phases).to receive(:cursor)
          .and_return(cursor)

        allow(duel_phases).to receive(:hand)
          .and_return(hand)

        allow(duel_phases).to receive(:player_1?)
          .and_return(true)

        allow(cursor).to receive(:new_current_obj)

        duel_phases.set_current_phase(:mp1)

        duel_phases.update

        expect(cursor).to have_received(:new_current_obj)

        expect(duel_phases.current_phase).to eq(:mp1)
      end

      it 'lets AI play if player is 2' do
        duel_phases = initialize_described_class
        timer   = instance_double(Timer, execute?: true)
        
        allow(duel_phases).to receive(:timer)
          .and_return(timer)
        
        allow(duel_phases).to receive(:player_1?)
          .and_return(false)

        duel_phases.set_current_phase(:mp1)
        expect(duel_phases).to receive(:ai_play).once

        duel_phases.update

        expect(duel_phases.current_phase).to eq(:mp1)
      end
    end

    context 'when the current phase is bp (Batle Phase)' do
      it 'changes all monsters to attack if is player turn' do
        duel_phases = initialize_described_class
        timer   = instance_double(Timer, execute?: true)
        
        battle_field = instance_double(Battle_Field,
          change_monsters_to_battle_position: true)

        allow(duel_phases).to receive(:timer)
          .and_return(timer)

        allow(duel_phases).to receive(:player_1?)
          .and_return(true)

        allow(duel_phases).to receive(:battle_field)
          .and_return(battle_field)

        duel_phases.set_current_phase(:bp)

        duel_phases.update

        expect(duel_phases.current_phase).to eq(:bp)
      end

      it 'changes all monsters to attack if is player turn' do
        duel_phases = initialize_described_class
        timer   = instance_double(Timer, execute?: true)
        
        battle_field = instance_double(Battle_Field,
          change_monsters_to_battle_position: true)

        allow(duel_phases).to receive(:timer)
          .and_return(timer)

        allow(duel_phases).to receive(:player_1?)
          .and_return(false)

        duel_phases.set_current_phase(:bp)

        duel_phases.update

        expect(duel_phases.current_phase).to eq(:bp)
      end
    end

    context 'when the current phase is ep (End Phase)' do
      it 'reset battle_field positions' do
        duel_phases = initialize_described_class
        timer   = instance_double(Timer, execute?: true)
        board_1 = instance_double(Board, reset_cards_position: true)

        allow(duel_phases).to receive(:timer)
          .and_return(timer)

        allow(duel_phases).to receive(:board)
          .and_return(board_1)

        expect(duel_phases).to receive(:start).once

        duel_phases.set_current_phase(:ep)

        duel_phases.update

        expect(duel_phases.turn_counter).to eq(2)
      end
    end
  end

  def initialize_described_class(board_1 = nil , board_2 = nil)
    board_1 = instance_double(Board, player: :player_1) if board_1.nil? 
    board_2 = instance_double(Board, player: :player_2) if board_2.nil?
    
    information_zone = instance_double(Information_Zone, set_current_phase: true)

    duel_phases = Duel_Phases.new(board_1, board_2, information_zone, :player_1)
  end
end