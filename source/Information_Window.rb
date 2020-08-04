class Information_Window < Window_Base
  def initialize(line_number = 2)
    super(0, Graphics.height - 50, Graphics.width, 50)
  end

  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end

  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
  end

  def clear
    set_text("")
  end
end