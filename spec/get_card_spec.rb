require 'httpclient'
require 'json'

describe "Card_Searcher" do
  it '#get_by_name' do
    character_name = 'yugi_muto'
    http_client = instance_double(HTTPClient, get_content: http_response)
    request_url = "https://db.ygoprodeck.com/api/v4/cardinfo.php?fname=Time%20Wizard" 

    allow(HTTPClient).to receive(:new)
      .and_return(http_client)

    allow(http_client).to receive(:get_content)
      .and_return(http_response)

    allow(File).to receive(:open)
      .and_return(true)
      
    get_card = Card_Searcher.new('character_name')

    card_name = 'Time Wizard'

    expect(get_card.find_by_name(card_name)).to be true
    expect(get_card.save_cards).to be true
    expect(http_client).to have_received(:get_content)
      .with(request_url)
  end

  def http_response
    File.read("spec/fixtures/api_card_response.json")
  end
end
