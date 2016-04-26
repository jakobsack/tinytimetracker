module ApplicationHelper
  def magic_font_color color
    m = RGB::Color.from_rgb_hex(color).to_rgb.sum
    m < 383 ? '#FFFFFF' : '#000000'
  end

  def time_start time
    return '' unless time
    time.strftime "%d.%m.%Y %H:%M:%S"
  end

  def time_end time
    return '' unless time
    time.strftime "%H:%M:%S"
  end

  def time_diff from, to
    return '' unless to

    diff = to - from
    s = ''
    if diff > 3600
      s += '%02ih ' % (diff / 3600).to_i
      diff -= (diff / 3600).to_i * 3600
    end
    if diff > 60 || s.length > 0
      s += '%02im ' % (diff / 60).to_i
      diff -= (diff / 60).to_i * 60
    end
    s += '%02is' % diff.to_i

    s
  end
end
