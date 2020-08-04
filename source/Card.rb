class Card < Game_Object #[TODO] remove game_object
  attr_accessor :x, :y, :slot, :attribute, :element, 
  :atk, :def, :effect, :window_card_action

  attr_reader :id, :name, :level,
  :type, :race, :type, :description, :state,
  :position, :location, :board, :conditions

  CARD_WIDTH = 24
  CARD_HEIGHT = 31

  STATES = [:none, :moving_to_center, :on_center, :ready_to_atk]
  
  def initialize(object_pool, card_attributes, x, y, board)
    super(object_pool)

    @x = x
    @y = y
    @state    = :none
    @location = :deck
    @position = :atk
    
    @phisycs  = Card_Physics.new(self) 
    @graphics = Card_Graphics.new(self)
    @commands = Card_Commands.new(self)
    @position_changed = false

    #[TODO] Criar Card_State quando for preciso
    #@states   = Card_State.new(self)

    @id             = card_attributes["id"]
    @name           = card_attributes["name"]
    self.atk        = card_attributes["atk"].to_i
    self.def        = card_attributes["def"].to_i
    @type           = card_attributes["type"]
    @race           = card_attributes["race"]
    self.attribute  = card_attributes["attribute"]
    @level          = card_attributes["level"]
    @description    = card_attributes["desc"]

    @board          = board

    @conditions     = [:hand, :field, :graveyard, :flip]

    self.effect = Effect.new(self)
    self.window_card_action = board.window_card_action
  end

  def text
    @name
  end

  def width
    CARD_WIDTH
  end

  def height
    CARD_HEIGHT
  end

  def face
    @phisycs.face
  end

  def z=(position)
    @graphics.z = position
  end

  def face_up
    @phisycs.face_up
    @graphics.face_up
  end

  def face_down
    @phisycs.face_down
    @graphics.face_down
  end

  def flip
    effect.activate if effect.can_activate?(:on_flip)
    face_up
  end

  def ready_to_atk
    @graphics.ready_to_atk
  end

  def to_def
    @position = :def
    slot = @board.battle_field.selected_slot
    @graphics.to_def
    @phisycs.to_def
    @position_changed = true
  end

  def to_atk
    @position = :atk
    slot = @board.battle_field.selected_slot
    @graphics.to_atk
    @phisycs.to_atk
    @position_changed = true
  end

  def reset_position
    @position_changed = false
  end

  def position_changed?
    @position_changed
  end

  def can_change_to_atk?
    return false if @position == :atk
    return false if position_changed?
    
    true
  end

  def can_change_to_def?
    return false if @position == :def
    return false if position_changed?
    return false if @state == :ready_to_atk || @state == :select_monster

    true
  end

  def location
    @location
  end

  def change_location(location)
    @location = location
  end

  #[STATES]
  #####################
  def select_monster
  end

  def waiting_to_atk

  end

  def none
    @graphics.remove_icons
    bright_off
  end

  def passive_to_receive_atk
    bright_on
  end

  def waiting_selection
    bright_on
  end

  def passive_to_selection
    bright_on
  end

  def perform_atk
    @graphics.remove_icons
  end

  def atk_effect(element)
    animation = $data_animations[element] #12
    @graphics.sprite.start_animation(animation)
  end

  def summon_effect
    @timer ||= Timer.new(2)

    return if !@timer.execute?
    @graphics.sprite.start_animation($data_animations[44])
    @timer = nil
  end

  def element
    effect_attribute = {
      water: 9,
      fire: 8,
      wind: 10,
      earth: 12,
      dark: 77,
      light: 75
    }

    effect_attribute[attribute.downcase.to_sym]
  end

  #[TODO] change name to destroy
  def dead
    change_state(:none)

    @graphics.to_atk
    slot = @board.battle_field.selected_slot
    slot.remove_selection
    send_to_graveyard
  end

  def send_to_graveyard
    slot.card = nil
    change_location(:graveyard)
    @board.graveyard.destroy_card(self)
  end
  
  def change_state(state)
    @state = state
    send(state)
  end

  def bitmap
    @graphics.bitmap
  end

  def sprite
    @graphics.sprite
  end

  def bright_on
    @graphics.bright = true
  end

  def bright_off
    @graphics.bright = false
    @graphics.sprite.opacity = 255 
    @graphics
  end

  def perform_ok
  end

  def update
    @graphics.update
  end

  def show
    @graphics.show
  end

  def can_summon?
    @commands.can_summon?
  end

  #[TODO] tornar privado
  def is_monster?
    puts "Monster Type: #{@type}"

    not [
      'Spell Card',
      'Trap Card'
    ].include?(@type)
  end

  def can_set?
    @commands.can_set?
  end

  def commands
    @commands.list
  end

  def terminate
    @graphics.dispose
  end

  def execute_effect?
    effect.can_execute?
  end
end
