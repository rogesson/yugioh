require 'httpclient'
require 'json'
require 'yaml'
require "open-uri"

class Card_Searcher
  API_URL = 'https://db.ygoprodeck.com/api/v4/cardinfo.php'
  CARD_IMAGES_URL = "http://storage.googleapis.com/ygoprodeck.com/"

  def initialize(character_name)
    @client = HTTPClient.new
    @cards = []
    @cards_error = []
    @character_name = character_name
  end

  def find_by_name(name)
    ocurrences = name.scan(/\d+/).last.to_i
    if false #ocurrences > 1
      ocurrences.times do
        name = name.split(" (x").first
        send_request(name)
      end
    else
      send_request(name)
    end

    true
  end

  def send_request(name)
    uri = URI.encode(API_URL + "?fname=#{name}")
    puts "Requesting: #{uri}"
    response = @client.get_content(uri)
    
    response = parse_response(response)

    card = create_card(response)

    build_card(card)
  rescue => e
    @cards_error << name
    puts "Error while getting #{name} card | character: #{@character_name}"
  end

  def show_errors
    puts "Cards not found: #{@cards_error.size} | character: #{@character_name}"

    @cards_error.each do |name|
      puts name
    end
  end
  
  def save_cards
    File.open("data/card_information/#{@character_name}", 'w+') do |f|
      f.write({ cards: @cards })
    end
    
    save_card_image
    print_card_types

    true
  end

  def save_card_image
    # normal: 98x143 
    @cards.each do |card|
      File.open("data/card_images/#{card[:id]}.png", 'wb') do |fo|
        fo.write open(CARD_IMAGES_URL + "pics/#{card[:id]}.jpg").read
      end
    end
  end

  private

    def print_card_types
      types = @cards.map do |card|
        card[:type]
      end

      puts "Types: #{types.uniq.inspect}"
    end

    def parse_response(response)
      JSON.parse(response)[0][0]
    end

    def create_card(card)
      info = {
        id:        card['id'],        # '81492226',
        name:      card['name'],      # 'ancient jar',
        desc:      card['desc'],      # 'a very fragile jar that contains something ancient and dangerous.',
        atk:       card['atk'],       # '400',
        def:       card['def'],       # '200',
        type:      card['type'],      # 'normal monster',
        level:     card['level'],     # '1',
        race:      card['race'],      # 'rock',
        attribute: card['attribute'], # 'earth'
        image_url: card['image_url']  # 'https://storage.googleapis.com/ygoprodeck.com/pics_small/81492226.jpg'
      }
    end

    def build_card(card)
      @cards << card
    end
end 

