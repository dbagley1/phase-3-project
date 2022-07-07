require "pry"
module ColorsHelper
  def hex_to_rgb(hex)
    match = hex.match(/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i)
    match ? [match[1].to_i(16), match[2].to_i(16), match[3].to_i(16)] : nil
  end

  def rgb_to_hex(r, g, b)
    r = r.to_s(16).rjust(2, "0")
    g = g.to_s(16).rjust(2, "0")
    b = b.to_s(16).rjust(2, "0")
    "##{r}#{g}#{b}"
  end

  def rgb_to_hsl(r, g, b)
    r /= 255.0
    g /= 255.0
    b /= 255.0
    max = [r, g, b].max
    min = [r, g, b].min
    h = (max + min) / 2.0
    s = (max + min) / 2.0
    l = (max + min) / 2.0

    if (max == min)
      h = 0
      s = 0 # achromatic
    else
      d = max - min
      s = l >= 0.5 ? d / (2.0 - max - min) : d / (max + min)
      case max
      when r
        h = (g - b) / d + (g < b ? 6.0 : 0)
      when g
        h = (b - r) / d + 2.0
      when b
        h = (r - g) / d + 4.0
      end
      h /= 6.0
    end

    return (h * 360).round, (s * 100).round, (l * 100).round
  end

  def hsl_to_rgb(h, s, l)
    h = h.to_f
    s = s.to_f / 100
    l = l.to_f / 100

    a = s * [l, 1 - l].min

    k1 = (0 + h / 30) % 12
    k2 = (8 + h / 30) % 12
    k3 = (4 + h / 30) % 12

    f1 = l - a * [-1, [k1 - 3, [9 - k1, 1].min].min].max
    f2 = l - a * [-1, [k2 - 3, [9 - k2, 1].min].min].max
    f3 = l - a * [-1, [k3 - 3, [9 - k3, 1].min].min].max

    return (255 * f1).to_i, (255 * f2).to_i, (255 * f3).to_i
  end

  def hex_to_hsl(hex)
    r, g, b = hex_to_rgb(hex)
    rgb_to_hsl(r, g, b)
  end

  def hsl_to_hex(h, s, l)
    r, g, b = hsl_to_rgb(h, s, l)
    return rgb_to_hex(r, g, b)
  end

  def delta_e(rgbA, rgbB)
    labA = rgb_to_lab(rgbA)
    labB = rgb_to_lab(rgbB)
    deltaL = labA[0] - labB[0]
    deltaA = labA[1] - labB[1]
    deltaB = labA[2] - labB[2]
    c1 = Math.sqrt(labA[1] * labA[1] + labA[2] * labA[2])
    c2 = Math.sqrt(labB[1] * labB[1] + labB[2] * labB[2])
    deltaC = c1 - c2
    deltaH = deltaA * deltaA + deltaB * deltaB - deltaC * deltaC
    deltaH = deltaH < 0 ? 0 : Math.sqrt(deltaH)
    sc = 1.0 + 0.045 * c1
    sh = 1.0 + 0.015 * c1
    deltaLKlsl = deltaL / (1.0)
    deltaCkcsc = deltaC / (sc)
    deltaHkhsh = deltaH / (sh)
    i = deltaLKlsl * deltaLKlsl + deltaCkcsc * deltaCkcsc + deltaHkhsh * deltaHkhsh
    return i < 0 ? 0 : Math.sqrt(i)
  end

  def rgb_to_lab(rgb)
    r, g, b = rgb.map { |i| i / 255.0 }
    # binding.pry
    r = (r > 0.04045) ? ((r + 0.055) / 1.055)**2.4 : r / 12.92
    g = (g > 0.04045) ? ((g + 0.055) / 1.055)**2.4 : g / 12.92
    b = (b > 0.04045) ? ((b + 0.055) / 1.055)**2.4 : b / 12.92
    # binding.pry
    x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
    y = (r * 0.2126 + g * 0.7152 + b * 0.0722) / 1.00000
    z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883
    # binding.pry
    x = (x > 0.008856) ? x**(1.0 / 3.0) : (7.787 * x) + 16.0 / 116.0
    y = (y > 0.008856) ? y**(1.0 / 3.0) : (7.787 * y) + 16.0 / 116.0
    z = (z > 0.008856) ? z**(1.0 / 3.0) : (7.787 * z) + 16.0 / 116.0
    # binding.pry
    lab = [(116 * y) - 16, 500 * (x - y), 200 * (y - z)]
    # binding.pry
    return lab
  end
end
