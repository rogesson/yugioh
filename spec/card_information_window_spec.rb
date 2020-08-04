require 'spec_helper.rb'

describe 'Card_Information_Window' do
  context 'when card is monster' do
    xit 'show monster information' do
      card = instance_double(Card)
      card_information_window = Card_Information_Window.new(
        x: 0,
        y: 0,
        width: 0,
        height: 0 
      )

      result = card_information_window.show_info(card)
      expec(result).to be true
    end
  end
end
