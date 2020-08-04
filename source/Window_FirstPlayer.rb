class Window_FirstPlayer < Window_Command
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    @commands = [
      { name: 'FIRST TO GO', key: :first_to_go, visible: true },
      { name: 'SECOND TO GO', key: :SECOND_to_go, visible: true }
    ]
    
    super(0, 0)
    update_placement
    self.openness = 0
    open
  end
  
  def window_width
    return 160
  end

  def commands=(commands)
    @commands = commands
    clear_command_list
    make_command_list
    create_contents
    refresh
    select(0)
  end

  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end

  def make_command_list
    @commands.each do |command|
      add_command(command[:name], command[:key], command[:visible])
    end
  end
end