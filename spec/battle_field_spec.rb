 require 'spec_helper'

describe Battle_Field do
  describe '#summon_monster' do
    context 'when there is a empty slot' do
      it 'summons a monster' do
        card = instance_double(Card, :slot= => nil, x: 0, y: 0)
        monster_slot = instance_double(MonsterSlot, card: nil, :card= => nil, x: 0, y: 0)
        spell_slot = instance_double(SpellSlot)

        #[TODO] receive in constructor
        allow(MonsterSlot).to receive(:new)
          .and_return(monster_slot)

        allow(SpellSlot).to receive(:new)
          .and_return(spell_slot)

        allow(card).to receive(:to_atk).once
        allow(card).to receive(:change_location).once

        battle_field = initialize_described_class

        expect(battle_field.summon_monster(card)).to eq(true)
        expect(card).to have_received(:to_atk)
        expect(card).to have_received(:change_location)
          .with(:on_battle_field)
      end
    end

    context 'when all slots is full with cards' do
      it 'does not summon this monster' do
        card = instance_double(Card, :slot= => nil, x: 0, y: 0)

        monster_slot = instance_double(MonsterSlot, card: "SomeCard", :card= => nil, x: 0, y: 0)
        spell_slot = instance_double(SpellSlot)

        #[TODO] receive in constructor
        allow(MonsterSlot).to receive(:new)
          .and_return(monster_slot)

        allow(SpellSlot).to receive(:new)
          .and_return(spell_slot)

        battle_field = initialize_described_class

        expect(battle_field.summon_monster(card)).to eq(false)
      end
    end
  end

#   describe "#board_player" do
#     it 'returns player board' do
#       battle_field = initialize_described_class

#       expect(battle_field.board_player)
#         .to eq(:player_1)
#     end
#   end

#   describe "#selected_card" do
#     it 'returns the selected card when card exists' do
#       battle_field = initialize_described_class

#       card = instance_double(Card)
#       slot = instance_double(MonsterSlot, card: card)

#       battle_field.select_object(slot)
#       expect(battle_field.selected_card).to eq(card)
#     end

#     it 'returns nil when slot is empty' do
#       battle_field = initialize_described_class

#       slot = instance_double(MonsterSlot, card: nil)

#       battle_field.select_object(slot)
#       expect(battle_field.selected_card).to be_nil
#     end
#   end
  
#   describe '#selected_object' do
#     it 'returns selected object' do
#       subject = initialize_described_class

#       object = Object.new
#       subject.select_object(object)
#       expect(subject.selected_object).to eq(object)
#     end
#   end

#   describe '#move_up' do
#     it 'returns board object if slot above is nil' do
#       subject = initialize_described_class
#       board = subject.instance_variable_get(:@board)

#       allow(subject).to receive(:slot_above)
#         .and_return(nil)

#       expect(subject.move_up).to eq(board)
#     end

#     it 'returns slot above if slot above is not nil' do
#       subject = initialize_described_class
#       board = subject.instance_variable_get(:@board)
#       monster_slot = instance_double(MonsterSlot)
#       allow(subject).to receive(:slot_above)
#        .and_return(monster_slot)

#       expect(subject.move_up).to eq(subject)
#     end
#   end

# #   describe '#move_down' do
# #     it 'returns spell slot bellow' do
# #       subject = initialize_described_class
# #       spell_slot = instance_double(SpellSlot)
# #       allow(subject).to receive(:slot_bellow)
# #         .and_return(spell_slot)

# #       subject.move_down
# #       expect(subject.selected_object).to eq(spell_slot)
# #     end
# #   end

  def initialize_described_class
    player = :player_1
    x = 0
    y = 0
    width = 100
    height = 100

    sprite = instance_double(Sprite)
    battle_field = instance_double(Battle_Field)
    opponent_board = instance_double(Board)
    board = instance_double(Board, 
      sprite: sprite,
      board_player: :player_1,
      opponent_board: opponent_board
    )

    Battle_Field.new(player, x, y, width, height, board)
  end
end