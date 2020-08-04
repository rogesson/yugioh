#[TODO] change to Window_Card_Information
class Card_Information_Window < Window_Base
  def initialize(x = 0, y = 210, width = 200, height = 150)
    super
    
    self.z = 303
    hide
    close

    @bitmap_star   = Bitmap.new("Graphics/System/star.png")
    @bitmap_sword  = Bitmap.new("Graphics/System/sword.png")
    @bitmap_shield = Bitmap.new("Graphics/System/shield.png")
    @card_sprite = Sprite.new
    @card_sprite.x = 5
    @card_sprite.bitmap = Bitmap.new(180, 143)
    @card_sprite.y = 62
  end

  #[TODO] create test
  def show_info(card)
    show
    contents.clear
    @card_sprite.bitmap.clear
    @card_sprite.visible = true if @card_sprite
    open
    
    @card = card

    card_bitmap = Bitmap.new("Graphics/Pictures/Cards/#{card.id}.png")
    @card_sprite.bitmap.blt(0, 0, card_bitmap, card_bitmap.rect)
    card_bitmap.dispose

    if card.is_monster?
      src_rect = Rect.new(0, 0, 525, 300)
      @card_sprite.bitmap.blt(100, 126, @bitmap_star, src_rect) 
      @card_sprite.bitmap.draw_text(120, 122, 30, 20, "X#{card.level}")

      contents.blt(0, 0, @bitmap_sword, src_rect)
      draw_text(30, 0, 200, 20, "#{card.atk}")
      contents.blt(75, 0, @bitmap_shield, src_rect)
      draw_text(105, 0, 200, 20, "#{card.def}")
      draw_text(0, 25, 200, 30, "[#{card.race}]")
    else
      draw_text(0, 0, 200, 30, "[#{card.type}]")
      draw_text(0, 25, 200, 30, "[#{card.race}]")
    end

    card_description = Word_Wrap.new(18, @card.description).break_line
    line_height = 45
    
    card_description.each do |line|
      draw_text(0, line_height, 200, 40, line)
      line_height += 20
    end
  end

  def show_descriptions
    self.y = 0
    self.width = 525
    self.height = 350
    draw_text(100, 0, 525, 30, @card.description)
  end

  def dispose
    super

    @bitmap_star.dispose
    @bitmap_sword.dispose
    @bitmap_shield.dispose
    @card_sprite.dispose
  end

  def close
    super
    @card_sprite.visible = false if @card_sprite
  end

  private

    def show_level(card)
      card.level != "0"
    end
end
