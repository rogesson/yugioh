class Image_Manager
  def self.draw_point(src_bitmap, x, y)
    #puts "drawing at #{src_bitmap} (#{x}, #{y})"
    bitmap = Bitmap.new(5, 5)
    bitmap.fill_rect(0, 0, 5,  5, Color.new(255, 0, 0))
    src_bitmap.blt(x, y, bitmap, bitmap.rect)
  end

  def self.draw_image(src_bitmap, sprite)
    src_bitmap.blt(sprite.x, sprite.y, sprite.bitmap, sprite.src_rect)
    sprite.update
  end

  def self.show_bitmap(bitmap)
    #bitmap.fill_rect(Rect.new(0, 0, bitmap.width, line_height), Color.new(255,255,255))
  end
end