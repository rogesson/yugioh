class Word_Wrap
  def initialize(max_length = 5, text)
    @text = text
    @max_length = max_length
  end

  def break_line
    words = @text.split(" ")
    line = ''
    lines = []
    new_line = true

    for word in words
      if line.size + word.size < @max_length
        line << "#{word} "
      else
        new_line = true
        line = "#{word} "
      end
      lines << line if new_line
      new_line = false
    end

    lines
  end
end

