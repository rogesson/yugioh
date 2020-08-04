require 'spec_helper.rb'

describe 'Brain' do
	describe '#update' do
		context 'when the current_action is :think' do
			it 'summon a monster' do
				brain = initialize_described_class

				monster = instance_double(Card, atk: 100)
				allow(brain).to receive(:summon_monster)
					.and_return(true)

				expect(brain.update).to be true 
			end
		end

		context 'when the current_action is :bp' do
			it 'sets current phase to :bp' do
				brain = initialize_described_class
				timer = instance_double(Timer, execute?: true)

				allow(brain).to receive(:timer)
					.and_return(timer)

				allow(brain).to receive(:moved?)
					.and_return(true)

				allow(brain).to receive(:set_current_phase)

				brain.current_action = :bp
				brain.update
				
				expect(brain).to have_received(:set_current_phase)
					.with(:bp)

				expect(brain.current_action).to eq(:change_monsters_to_battle_position)
			end
		end

		context 'when current_action is :change_monsters_to_battle_position' do
			it 'changes monsters to battle position' do
				brain = initialize_described_class

				allow(brain).to receive(:change_monsters_to_battle_position)
					.and_return(true)

				brain.current_action = :change_monsters_to_battle_position
				brain.update

				expect(brain).to have_received(:change_monsters_to_battle_position).once
				expect(brain.current_action).to eq(:atk_player_monsters) 
			end
		end

		context 'when current_action is :atk_player_monsters' do
			it 'attacks player monsters' do
				brain = initialize_described_class

				timer = instance_double(Timer, execute?: true, reset: true)

				allow(brain).to receive(:atk_player_monsters)
					.and_return(true)

				allow(brain).to receive(:timer)
					.and_return(timer)

				brain.current_action = :atk_player_monsters
				brain.update

				expect(brain).to have_received(:atk_player_monsters).once

				expect(brain.current_action).to eq(:ep) 
			end
		end

		context 'when current_action is :ep' do
			it 'attacks player monsters' do
				brain = initialize_described_class

				allow(brain).to receive(:set_current_phase)

				brain.current_action = :ep
				brain.update

				expect(brain).to have_received(:set_current_phase)
				.with(:ep)
				.once

				expect(brain.current_action).to eq(:initial) 
			end
		end
	end

	describe '#summon_monster' do
		context 'when there is no monster to summon' do
			it 'summons nothing and go to the battle phase if there are other monsters on the field' do
				brain = initialize_described_class

				card = instance_double(Card)

				allow(brain).to receive(:monsters_allowed_to_summon)
					.and_return([])

				allow(brain).to receive(:ai_monsters_on_field)
					.and_return([card])

				allow(brain).to receive(:set_current_phase)
					.and_return(:bp)

				expect(brain.summon_monster).to eq(:bp)
			end
		end

		context 'when there is no monster to summon' do
			it 'goes to the end phase if there is no monster on the ai field' do
				brain = initialize_described_class

				allow(brain).to receive(:monsters_allowed_to_summon)
					.and_return([])

				allow(brain).to receive(:ai_monsters_on_field)
					.and_return([])

				allow(brain).to receive(:set_current_phase)
					.and_return(:ep)

				expect(brain.summon_monster).to eq(:ep)
			end
		end

		context 'when ai stronger monster is weaker than player monsters on the field' do
			it 'sets a monster in defensive mode and finish the turn' do
				brain = initialize_described_class

				ai_strong_monster = instance_double(Card, atk: 300)
				ai_weaker_monster = instance_double(Card, atk: 200)

				player_weaker_monster = instance_double(Card, atk: 1000)

				allow(brain).to receive(:monsters_allowed_to_summon)
					.and_return([ai_strong_monster, ai_weaker_monster])

				allow(brain).to receive(:player_weaker_atk_monster)
					.and_return(player_weaker_monster)

				expect(brain).to receive(:set_monster)
					.with(ai_strong_monster)
					.and_return(true)

				expect(brain.summon_monster).to eq(:ep)
			end
		end

		context 'when ai strong monster is stronger than player monster on the field' do
			it 'summons that monster' do
				brain = initialize_described_class

				ai_strong_monster = instance_double(Card, atk: 500)

				player_weaker_monster = instance_double(Card, atk: 100)

				allow(brain).to receive(:monsters_allowed_to_summon)
					.and_return([ai_strong_monster])

				allow(brain).to receive(:player_weaker_atk_monster)
					.and_return(player_weaker_monster)

				expect(brain).to receive(:perform_summon)
					.with(ai_strong_monster)
					.and_return(true)

				expect(brain).to receive(:turn_counter)
					.and_return(2)

				expect(brain.summon_monster).to eq(:bp)
			end
		end
	end

  describe '#perform_atk' do
  	context 'when player monster atk is weaker than ai monster' do
	  	it 'attacks the monster' do
				brain = initialize_described_class

	      offensive_card 		= instance_double(Card, atk: 1200)
	      player_weaker_monster = instance_double(Card, atk: 400, position: :atk, face: :up)

				allow(brain).to receive(:player_monsters_on_field)
					.and_return([player_weaker_monster])
	        
	      expect(brain.perform_atk(offensive_card)).to eq(true)
	    end
  	end

  	context 'when player monster def is weaker than ai monster' do
	  	it 'attacks that defensive monster' do
				brain = initialize_described_class

	      offensive_card = instance_double(Card, atk: 400)

	      player_stronger_monster = instance_double(Card, atk: 2000, position: :atk, face: :up)
				player_def_monster = instance_double(Card, atk: 2000, def: 100, position: :def, face: :up)

				allow(brain).to receive(:player_monsters_on_field)
					.and_return([player_stronger_monster, player_def_monster])

				expect(brain).to receive(:battle)
					.with(offensive_card, player_def_monster)
					.and_return(true)
	        
	      expect(brain.perform_atk(offensive_card)).to eq(true)
	    end
  	end

  	context 'when player monster def is stronger than ai monster' do
	  	it 'skips this attack' do
				brain = initialize_described_class

	      offensive_card = instance_double(Card, atk: 400)

	      player_stronger_monster = instance_double(Card, atk: 2000, position: :atk, face: :up)
				player_def_monster = instance_double(Card, atk: 2000, def: 3000, position: :def, face: :up)

				allow(brain).to receive(:player_monsters_on_field)
					.and_return([player_stronger_monster, player_def_monster])

				expect(brain).to_not receive(:battle)
	        
	      expect(brain.perform_atk(offensive_card)).to eq(false)
	    end
  	end

  	context 'when player monster is stronger than ai monster' do
	  	it 'attacks one of face down monster' do
				brain = initialize_described_class

	      offensive_card 		= instance_double(Card, atk: 400)

	      player_stronger_monster = instance_double(Card, atk: 2000, position: :atk, face: :up)
				player_face_down_monster = instance_double(Card, atk: 2000, def: 100, position: :def, face: :down)

				allow(brain).to receive(:player_monsters_on_field)
					.and_return([player_stronger_monster, player_face_down_monster])

				expect(brain).to receive(:battle)
					.with(offensive_card, player_face_down_monster)
					.and_return(true)
	        
	      expect(brain.perform_atk(offensive_card)).to eq(true)
	    end
  	end

  	context 'when there is no monster to battle with' do
  		it 'attacks the player directly' do
  			brain = initialize_described_class

	      offensive_card = instance_double(Card, atk: 400, element: :water, state: nil)

	      allow(brain).to receive(:player_monsters_on_field)
					.and_return([])

				allow(brain).to receive(:direct_atk)
					.with(offensive_card)
					.and_return(true)
	      
	      expect(brain.perform_atk(offensive_card)).to eq(true)
  		end
  	end
  end

	describe '#change_monsters_to_battle_position' do
		it 'change all monsters state to ready_to_atk status' do
			brain = initialize_described_class

      atk_monster = instance_double(Card, position: :atk)
      def_monster = instance_double(Card, position: :def)

			allow(brain).to receive(:ai_monsters_on_field)
				.and_return([atk_monster, def_monster])

			expect(atk_monster).to receive(:change_state)
				.with(:ready_to_atk)
			
			expect(brain.change_monsters_to_battle_position)
				.to eq([atk_monster])

			expect(brain.monster_atk_queue)
				.to eq([atk_monster])
		end
	end

	describe '#battle' do
		it 'calls battle between two cards' do
			brain = initialize_described_class
			offensive_card = instance_double(Card, position: :atk)
			defensive_card = instance_double(Card, position: :atk)

			expect(brain.battle(offensive_card, defensive_card))
				.to be true
		end
	end

	describe '#current_action' do
		it 'returns the current action name' do
			brain = initialize_described_class
			brain.current_action = :go_to_battle_phase

			expect(brain.current_action).to eq(:go_to_battle_phase)
		end
	end

  def initialize_described_class
		battle_field = instance_double(Battle_Field, battle_x: true)
		board_1 		 = instance_double(Board)
		board_2 		 = instance_double(Board, battle_field: battle_field)
		Brain.new(board_1, board_2)
	end
end
