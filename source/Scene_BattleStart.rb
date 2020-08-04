class Scene_BattleStart < Scene_Base
  attr_accessor :player_selected_card, :opponent_selected_card,
                :player_cards, :opponent_cards, :card_in_center,
                :battle_result, :window_first_player
  
  def initialize
    @cards_bitmap = Bitmap.new("Graphics/System/scissors_rock_paper.png")
    @card_width   = @cards_bitmap.width / 3 
    @card_height  = @cards_bitmap.height
    
    @player_cards_y       = 290
    @opponent_cards_y     = 5
    @player_cards         = []
    @opponent_cards       = []
    @motions              = []
    self.battle_result    = nil
    self.card_in_center   = false
  end

  def start
    super

    create_window_first_player
    create_battlegroud_sprite
    create_info_box
    create_cards
    select_first_card

    window_first_player.close

    true
  end
  
  def update
    super

    return if window_first_player.open?

    update_input
    update_card_position

    true
  end

  #[TODO] Create test
  def terminate
    super
    
    @info_box.dispose
    player_cards.each { |card| card[:sprite].dispose }
    opponent_cards.each { |card| card[:sprite].dispose }
  end

  #[TODO] Remove this from SceneBattle class
  def transition_speed
    50
  end

  #[TODO] REMOVE DUPLICATION FROM HAND
  ########################################
  def select_first_card
    select_object(player_cards.first)
  end
 
  def previous_card
    card_index = player_cards.index(player_selected_card)
    card = player_cards[card_index - 1]

    card = player_cards.last if card.nil?
    select_object(card)
  end

  def next_card
    card_index = player_cards.index(player_selected_card)
    card = player_cards[card_index + 1]

    card = player_cards.first if card.nil?
    select_object(card)
  end

  def select_object(obj)
    reset_card_position
    obj[:sprite].y -= 10

    self.player_selected_card = obj

    self
  end

  def reset_card_position
    if player_selected_card
      player_selected_card[:sprite].y = @player_cards_y
    end
  end

  #[TODO] Call Scene_Battle card with first player as param
  def first_to_go
    $first_player = :player_1
    SceneManager.call(Scene_BattleCard)
  end

  #[TODO] Call Scene_Battle card with first player as param
  def second_to_go
    $first_player = :player_2
    SceneManager.call(Scene_BattleCard)
  end

 ########################################
  private
  
    def create_card(player, type, x, y) 
      card_types = {
       scissors: { index: 0 },
       rock:     { index: 1 },
       paper:    { index: 2 }
      }

      card = {
        player: player,
        name: type,
        type: card_types[type],
        original_position: { x: x, y: y } 
      }

      sprite = Sprite.new
      sprite.x = x
      sprite.y = y

      sprite.bitmap = @cards_bitmap
      
      sprite.src_rect
        .set(card[:type][:index] * @card_width, 0, @card_width, @card_height)

      card[:sprite] = sprite

      card
    end

    def create_info_box
      @info_box = Sprite.new
      @info_box.bitmap = Bitmap.new("Graphics/System/info_box.png")

      #[TODO] create method to align at center and remove this
      @info_box.x = (Graphics.width / 2) - @info_box.width / 2
      @info_box.y = (Graphics.height / 2) - @info_box.height / 2 - 30

      #[TODO] Create method to draw text in the center of the box
      @info_box.bitmap
      info_box_write("SELECT A CARD")
    end

    def info_box_write(text)
      @info_box.bitmap.clear

      text_size = text.size

      @info_box.bitmap = Bitmap.new("Graphics/System/info_box.png")
      @info_box.bitmap
        .draw_text((@info_box.width / 2) - text_size * 5, 10, 400, 30, text)
    end

    def create_battlegroud_sprite
      @back_ground_sprite = Sprite.new
      @back_ground_sprite
        .bitmap = Bitmap.new("Graphics/System/background_battle.jpg")
    end

    def create_cards
      self.player_cards  = create_player_cards
      self.opponent_cards = create_opponent_cards
    end

    #[TODO] make private #[TODO] merge with create_opponent_cards
    def create_player_cards
      cards = []
      cards << create_card(1, :scissors, 190, @player_cards_y)
      cards << create_card(1, :rock, 250, @player_cards_y)
      cards << create_card(1, :paper, 310, @player_cards_y)
    end

    #[TODO] Make private #[TODO] merge with create_player_cards
    def create_opponent_cards
      cards = []
      cards << create_card(2, :scissors, 190, @opponent_cards_y)
      cards << create_card(2, :rock, 250, @opponent_cards_y)
      cards << create_card(2, :paper, 310, @opponent_cards_y)
    end
    
    def hide_info_box
      @info_box.visible = false
    end

    def show_info_box
      @info_box.visible = true
    end

    def update_input
      if Input.trigger?(:C)
        send_cards_to_center unless card_in_center
        send_cards_to_original_position if card_in_center
        
        if battle_result
          return if battle_result == :draw
          if battle_result == :lose
            visible = [true, false].shuffle
            commands = [
              { name: 'FIRST TO GO', key: :first_to_go, visible: visible[0] },
              { name: 'SECOND TO GO', key: :second_to_go, visible: visible[1] }
            ]
          else
            commands = [
              { name: 'FIRST TO GO', key: :first_to_go, visible: true },
              { name: 'SECOND TO GO', key: :second_to_go, visible: true }
            ]
          end

          window_first_player.commands = commands

          hide_all_cards
          hide_info_box
          window_first_player.open
        end
        return true
      end

      return if card_in_center

      if Input.trigger?(:LEFT)
        previous_card
      end

      if Input.trigger?(:RIGHT)
        next_card
      end
    end
    
    def update_card_position
      return if @motions.empty?

      @motions.each do |motion|
        position = motion.move

        motion.object[:sprite].x = position.x
        motion.object[:sprite].y = position.y

        if motion.moved?
          motion.execute
          @motions.delete(motion)
        end
      end
      
      if @motions.empty?
        if card_in_center == true
          self.battle_result = calculate_results(player_selected_card, opponent_selected_card)
          @info_box.y = @player_cards_y
          case battle_result
          when :win
            info_box_write('WIN!!!')
          when :lose
            info_box_write('LOSE')
          else
            info_box_write('DRAW')
          end
        end
      end
    end

    def send_cards_to_center
      self.opponent_selected_card = opponent_cards.sample
      hide_cards
      send_card_to_center(player_selected_card)
      send_card_to_center(opponent_selected_card)
    end

    def send_card_to_center(card)
      sprite        = card[:sprite]
      position      = Vector2d.new(sprite.x, sprite.y)
      diff          = card[:player] == 1 ? -30 : 80
      destination   = Vector2d.new(Graphics.width / 2 - sprite.width / 2, Graphics.height / 2 - sprite.height / 2 - diff)
      #[TODO] Receive object
      motion        = Motion.new(position, destination, 1) do
        self.card_in_center = true
      end
      motion.object = card
      @motions << motion
    end

    def send_cards_to_original_position
      show_info_box
      show_cards

      send_card_to_original_position(player_selected_card)
      send_card_to_original_position(opponent_selected_card)

      @info_box.y = (Graphics.height / 2) - @info_box.height / 2 - 30
      info_box_write('SELECT A CARD')
    end

    def send_card_to_original_position(card)
      sprite = card[:sprite]
      original_position = card[:original_position]

      position    = Vector2d.new(sprite.x, sprite.y)
      destination = Vector2d.new(original_position[:x], original_position[:y])
      motion = Motion.new(position, destination, 1) do
        self.card_in_center = false
      end
      motion.object = card
      @motions << motion
    end

    def hide_cards
      cards = player_cards.reject { |card|  card == player_selected_card }
      cards += opponent_cards.reject { |card|  card == opponent_selected_card }
      cards.each { |card| card[:sprite].visible = false }
    end

    def show_cards
      cards = player_cards.reject { |card|  card == player_selected_card }
      cards += opponent_cards.reject { |card|  card == opponent_selected_card }

      cards.each { |card| card[:sprite].visible = true }
    end

    def hide_all_cards
      cards = player_cards
      cards += opponent_cards
      cards.each { |card| card[:sprite].visible = false }
    end

    def calculate_results(player_card, opponent_card)
      if player_card[:name] == opponent_card[:name]
        return :draw
      end

      if player_card[:name] == :scissors
        if opponent_card[:name] == :paper
          return :win
        else
          return :lose
        end
      end

      if player_card[:name] == :paper
        if opponent_card[:name] == :rock
          return :win
        else
          return :lose
        end
      end

      if player_card[:name] == :rock
        if opponent_card[:name] == :scissors
          return :win
        else
          return :lose
        end
      end
    end

    def create_window_first_player
      self.window_first_player = Window_FirstPlayer.new
      window_first_player.set_handler(:first_to_go, method(:first_to_go))
      window_first_player.set_handler(:second_to_go, method(:second_to_go))
    end
end
