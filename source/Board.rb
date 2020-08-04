class Board
  attr_accessor :current_window, :window_card_action, :window_phase_action,
                :x, :y
  attr_reader   :sprite, :player, :width, :life_points, :player_face

  def initialize(player, player_face, x, y, mirror = false)
    @player = player
    @x = x
    @y = y
    @current_window      = nil
    @window_card_action  = nil
    @window_phase_action = nil
    @sprite              = Sprite.new
    @mirror              = mirror
    @objects             = []
    @life_points         = 8000
    @life_timer          = Timer.new(0.01, :life_timer)
    @damage_timer        = Timer.new(2, :damage_timer)
    @player_face = player_face

    #[TODO] deixar nome dinâmico
    @player_name         = player == :player_1 ? 'Yugi M.' : 'Joey W.' 

    @width = 211
    @height = 125
    @bitmap_board = Bitmap.new(@width, @height)
  
    #[TODO] Remove from here and use #draw method    
    draw_board
    create_panel
    create_life_point
  end

  #[TODO] Create acessor
  def deck
    @deck
  end

  #[TODO] Create acessor
  def hand
    @hand
  end

  def battle_field
    @battle_field
  end
  
  def selected_card
    hand.selected_card || battle_field.selected_card 
  end

  #[TODO] need test
  def reset_cards_position
    @hand.reset_card_position
    @battle_field.reset_all_card_position
    @battle_field.reset_all_cards_state
    @battle_field.reset_summoned_monsters_block
  end

  def cursor
    @cursor
  end

  #[TODO] Create spec
  def receive_direct_damage(received_atk, element)
    player_face.receive_damage(element)
    receive_damage(received_atk)
  end

  def receive_damage(received_atk)
    #[TODO] can be removed?
    #return if not @damage_timer.execute?
    
    @life_points -= received_atk
    @life_points = 0 if @life_points <= 0

    update_life_points

    @damage_timer.reset
  end

  def board_player
    @player
  end

  def opponent_board
    if @player == :player_1
      SceneManager.scene.board_p2
    else
      SceneManager.scene.board_p1
    end
  end

  def perfom_draw
    @deck.perform_draw
  end

  def add(object)
    @objects << object
    instance_name = underscore(object.class)
    instance_variable_set("@#{instance_name}", object)
    
    singleton_class.class_eval { attr_accessor instance_name }
  end

  def draw
    draw_board
    @battle_field.draw
  end

  def update
    player_face.update
    
    if lost?
      scene = player == :player_2 ? Scene_Win : Scene_Lost
      SceneManager.goto(scene)
    end
  end

  def terminate
    player_face.terminate

    @duel_panel.dispose
    @window_card_action.dispose if @window_card_action
    @window_phase_action.dispose if @window_phase_action
    @sprite.dispose
    @objects.each do |obj| 
      obj.terminate
    end
  end

  def underscore(camel_cased_word)
   camel_cased_word.to_s.gsub(/::/, '/').
     gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
     gsub(/([a-z\d])([A-Z])/,'\1_\2').
     tr("-", "_").
     downcase
  end

  def update_life_points
    @duel_panel.bitmap.clear
    create_panel
    @duel_panel.bitmap.draw_text(10, 0, 250, 25, "#{@player_name} - LP: #{@life_points}")    
  end


  private
    #[TODO] remove #add method and create accessors

    def lost?
      @life_points <= 0
    end

    def create_panel
      if @player == :player_1
        @duel_panel = Sprite.new
        @duel_panel.bitmap = Bitmap.new('Graphics/System/duel_panel_player')
        @duel_panel.x = 343
        @duel_panel.opacity = 220
      else
        @duel_panel = Sprite.new
        @duel_panel.bitmap = Bitmap.new('Graphics/System/duel_panel_opponent')
        @duel_panel.x = 114
        @duel_panel.opacity = 220
      end
    end

    def create_life_point
      @duel_panel.bitmap.draw_text(10, 0, 250, 25, "#{@player_name} - LP: #{@life_points}")
    end

    #[TODO] rename to draw
    def draw_board
      @sprite.x = @x
      @sprite.y = @y

      player_face.draw
      @sprite.bitmap = @bitmap_board
    end
end
