class Game_Object
  def initialize(object_pool = SceneManager.scene.object_pool)
    @components = []
    @object_pool = object_pool
    @object_pool.objects << self 
  end

  def components
    @components
  end

  def update
    @components.map(&:update)
  end

  def draw(viewport = nil)
    @components.each { |component| component.draw }
  end

  def removable?
    @removable
  end

  protected

    def object_pool
      @object_pool
    end
end