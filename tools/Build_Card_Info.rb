require_relative('card_searcher')

character = [
  #'yugi_muto',
  'joey_wheeler'
]

character.each do |character_name|
  get_card = Card_Searcher.new(character_name)

  deck = File.readlines("data/card_list/#{character_name}").each do |card_name|
    card_name = card_name.chomp
    puts card_name.inspect
    get_card.find_by_name(card_name)
  end
 
  get_card.save_cards
  get_card.show_errors
end

