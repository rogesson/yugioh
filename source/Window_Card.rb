class Window_Card < Window_Selectable

  attr_accessor :card

  def initialize
    super(0, 0, Graphics.width, Graphics.height - 50)

    self.z = 303
    hide
    close

    @sprites = []
    #[todo] Dispose
    @bitmap_star   = Bitmap.new("Graphics/System/star.png")
    @bitmap_sword  = Bitmap.new("Graphics/System/sword.png")
    @bitmap_shield = Bitmap.new("Graphics/System/shield.png")

    @card_sprite = Sprite.new
    @card_sprite.x = 10
    @card_sprite.y = 10
    @card_sprite.z = 303
    @card_sprite.bitmap = Bitmap.new(180, 143)
    @sprites << @card_sprite
  end

  def open
    super

    show
    activate
    contents.clear
    @card_sprite.bitmap.clear

    card_bitmap = Bitmap.new("Graphics/Pictures/Cards/#{card.id}.png")
    @card_sprite.bitmap.blt(0, 0, card_bitmap, card_bitmap.rect)
    card_bitmap.dispose

    if card.is_monster?
      src_rect = Rect.new(0, 0, 525, 300)
      contents.blt(0, 205, @bitmap_star, src_rect) 
      contents.draw_text(20, 200, 30, 20, "X#{card.level}")

      contents.blt(0, 155, @bitmap_sword, src_rect)
      draw_text(25, 155, 200, 20, "#{card.atk}")
      contents.blt(75, 155, @bitmap_shield, src_rect)
      draw_text(100, 155, 200, 20, "#{card.def}")
      draw_text(0, 175, 155, 30, "[#{card.race}]")
    else
      draw_text(0, 150, 200, 30, "[#{card.type}]")
      draw_text(0, 175, 200, 30, "[#{card.race}]")
    end

    card_description = Word_Wrap.new(38, @card.description).break_line
    line_height = -37
    
    card_description.each do |line|
      draw_text(150, line_height, 400, 100, line)
      line_height += 20
    end
  end


  def close
    super

    @card_sprite.bitmap.clear if @card_sprite
  end

  def dispose
    super

    sprites.map(&:dispose)
  end

  private
  
    attr_accessor :sprites
end