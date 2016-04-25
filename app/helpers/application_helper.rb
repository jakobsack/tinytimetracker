module ApplicationHelper
  def magic_font_color color
    m = RGB::Color.from_rgb_hex(color).to_rgb.sum
    m < 383 ? '#FFFFFF' : '#000000'
  end
end
