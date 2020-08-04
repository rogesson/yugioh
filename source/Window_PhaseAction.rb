class Window_PhaseAction < Window_Command
  def initialize(commands, board)
    @commands = commands
    calculate_width
    center_x = (Graphics.width / 2) - window_width / 2
    center_y = Graphics.height / 2
    @board = board

    super(center_x, center_y)
    self.openness = 0
    self.z = 401

    deactivate
  end

  def make_command_list
    @commands.each do |command|
      add_command(command[:name], command[:key], command[:visible])
    end
  end

  def window_width
    @width
  end

  def visible_line_number
    @commands.size
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

    def calculate_width
      @width = @commands.map { |command| command[:name].size }.max * 12
    end
end