class InputManager
  def initialize(cursor)
    @cursor = cursor
  end
  
  def update
    return if not @cursor.active?
    
    if Input.trigger?(:LEFT)
      @cursor.move_to(:LEFT)
    end

    if Input.trigger?(:RIGHT)
      @cursor.move_to(:RIGHT)
    end

    if Input.trigger?(:DOWN)
      @cursor.move_to(:DOWN)
    end

    if Input.trigger?(:UP)
      @cursor.move_to(:UP)
    end

    if Input.trigger?(:C)
      @cursor.perform_ok
    end

    if Input.trigger?(:B)
      SceneManager.scene.open_phase_actions
    end
  end
end