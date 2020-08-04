class Timer
  DEBUG = false

  def initialize(frame_delay, id = 'unknown')
    @frame_delay = Scene_BattleCard::DEBUG_MODE ? 0.1 : frame_delay
    @id = id
  end

  def execute?
    now = Time.now.to_f
    if now - (@last_time ||= 0) > @frame_delay
      @last_time = now
      return true
      puts "Timer #{@id} | #{now - (@last_time ||= 0)} > #{@frame_delay}" if DEBUG
    end
    puts "Timer #{@id} | #{now - (@last_time ||= 0)} > #{@frame_delay}" if DEBUG

    false
  end

  def reset
    @last_time = Time.now.to_f
  end
end
