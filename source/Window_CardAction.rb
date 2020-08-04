class Window_CardAction < Window_Command

  attr_writer :card_commands

  def initialize(board)
    @board = board
    
    super(0, 0)

    self.openness = 0
    self.z = 401
    deactivate
  end

  def make_command_list
    card_commands.each do |command|
      add_command(command[:name], command[:key], command[:visible])
    end
  end

  def window_width
    115
  end

  def visible_line_number
    card_commands.size
  end

  def show_commands(card)
    @board.cursor.deactivate
    @card = card
    self.card_commands = card.commands

    command_close = SceneManager.scene.method(:close_current_window)
    set_handler(:cancel, command_close)
    card_commands.each do |command|
      scene_command = SceneManager.scene.method("command_#{command[:key]}".to_sym)
      puts "#{command} | #{scene_command}"
      set_handler(command[:key], scene_command)
    end

    self.x = card.x - (window_width / 2) + (Card::CARD_WIDTH / 2)
    self.y = Graphics.height / 2
    self.height = fitting_height(visible_line_number)

    @board.current_window = self
    clear_command_list
    make_command_list
    create_contents
    refresh
    select(0)
    activate
    open
  end

  def setup
    @board.current_window = self
    clear_command_list
    make_command_list
    create_contents
    refresh
    select(0)
    activate
    open
  end

  private

    def card_commands
      @card ? @card.commands : []
    end
end
