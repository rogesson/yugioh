require 'spec_helper.rb'

describe 'Animation' do
  describe '.find' do
    it 'finds animation by element id' do
      $data_animations = { 31 =>  "animation" }

      expect(Animation.find(31)).to eq("animation")
    end
  end
end
