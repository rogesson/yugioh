require 'spec_helper.rb'

describe 'Player_Face' do
  describe "#draw" do
    it 'draws the face frame of player' do
      player_face = Player_Face.new(:player_1, 'yugi', 0, 0)

      expect(player_face.draw).to be true
    end
  end

  describe "receive_damage" do
    it 'shows damage effect on the face of player' do
      player_face = Player_Face.new(:player_1, 'yugi', 0, 0)
      element = 41

      allow(Animation).to receive(:find)
        .with(element)

      player_face.draw
      expect(player_face.receive_damage(element)).to eq(true)
    end
  end
end