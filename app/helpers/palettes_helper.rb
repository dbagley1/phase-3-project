require "pry"
module PalettesHelper
  @@minSat = 50
  @@maxSat = 70
  @@minLight = 50
  @@maxLight = 80
  @@minDistance = 15
  @@phi = ((1 + Math.sqrt(5)) / 2 - 1) * 0.1

  def generate_color_palette_v2(seed = Faker::Color.hex_color, count = 10)
    h, s, l = hex_to_hsl(seed)
    seed_rgb = hex_to_rgb(seed)

    golden_ratio_hues = []

    golden_ratio_hues = (count * 3).times.map { |i| (((h / 360.0 + @@phi * rand(0.1..1.0) * i) % 1) * 360).to_i }
    hsl_colors = golden_ratio_hues.map { |h| [h, rand(@@minSat..@@maxSat), rand(@@minLight..@@maxLight)] }
    hsl_colors.each_with_index do |hsl, i|
      if i != 0 && hsl[0].between?(30, 70)
        hsl[0] < 50 ? hsl[0] -= 40.32 : hsl[0] += 40.32
        hsl[0] = hsl[0] % 360
        # hsl[1] = hsl[1].clamp(75..)
      end
    end
    hex_colors = hsl_colors.map { |hsl| hsl_to_hex(*hsl) }
    rgb_colors = hex_colors.map { |hex| hex_to_rgb(hex) }

    unique_colors = []

    # Find the closest color in the lab color space
    rgb_colors.each.with_index do |rgbA, i|
      distances = []
      distances.push(*rgb_colors.slice(i + 1..).map { |rgbB| delta_e(rgbA, rgbB) }) if (i < rgb_colors.length - 1)
      distances.push(delta_e(rgbA, seed_rgb)) # compare with seed color
      distances.push(delta_e(rgbA, [170, 120, 50]) - 15) # compare with dark yellow
      distances.push(delta_e(rgbA, [220, 170, 80]) - 15) # compare with bright yellow
      distances.push(delta_e(rgbA, [214, 174, 30]) - 15) # compare with bright yellow
      closest = distances.min
      unique_colors << hex_colors[i] if closest > @@minDistance
    end

    [seed, *unique_colors.sample(count - 1)]
  end

  def generate_color_palette_v3(seed_hex, count = 5)
    @@minDistance = 17

    seed_rgb = hex_to_rgb(seed_hex)

    unique_rgb_colors = [seed_rgb]

    (1..count - 1).each { |i| unique_rgb_colors << find_new_color(seed_hex, unique_rgb_colors, i) }

    unique_hex_colors = unique_rgb_colors.map { |color| rgb_to_hex(*color) }
    # unique_hex_colors.sort_by { |hex| hex_to_hsl(hex)[0] }
  end

  def find_new_color(seed_hex, curr_colors, seed_num = 1)
    new_color = golden_ratio_color(seed_hex, seed_num)
    new_rgb = hsl_to_rgb(*new_color)
    closest = closest_distance(new_rgb, curr_colors)
    closest > @@minDistance ? new_rgb : find_new_color(seed_hex, curr_colors, seed_num + 1)
  end

  def golden_ratio_color(seed_hex, seed_num = 1)
    h, s, l = hex_to_hsl(seed_hex)

    hue = (((h / 360.0 + @@phi * rand(-10.0..10.0) * seed_num) % 1) * 360).to_i
    hsl = [hue, rand(@@minSat..@@maxSat), rand(@@minLight..@@maxLight)]

    if hsl[0].between?(50, 70)
      hsl[0] < 60 ? hsl[0] -= 20.16 : hsl[0] += 20.16
      hsl[0] = hsl[0].abs % 360
      hsl[1] = hsl[1].clamp(75..)
    end

    hsl
  end

  def closest_distance(rgbA, rgb_colors)
    distances = [100]
    distances.push(*rgb_colors.map { |rgbB| delta_e(rgbA, rgbB) })
    distances.push(delta_e(rgbA, [168, 117, 50])) # compare with dark yellow
    distances.min_by { |d| d }
  end

  def sort_colors_by_hue(colors)
    colors.sort_by { |color| hex_to_hsl(color.hex)[0] }
  end

  def sort_colors_by_saturation(colors)
    colors.sort_by { |color| hex_to_hsl(color.hex)[1] }
  end

  def sort_colors_by_lightness(colors)
    colors.sort_by { |color| hex_to_hsl(color.hex)[2] }
  end

  def find_random_unique_color(curr_colors)
    new_hsl = Faker::Color.hsl_color
    new_hsl[1] = rand(60..90)
    new_hsl[2] = rand(40..90)
    new_rgb = hsl_to_rgb(*new_hsl)
    closest = closest_distance(new_rgb, curr_colors)
    closest > @@minDistance ? new_rgb : find_random_unique_color(curr_colors)
  end

  def random_palette_name
    Faker::Marketing.buzzwords.titleize
  end

  # DEPRECATED

  def color_palettes_for(hex, count = 5)
    h, s, l = hex_to_hsl(hex)
    h = (h.to_f) / 360

    @@minSat = 60
    @@maxSat = 90
    s = s.clamp(@@minSat, @@maxSat)

    @@minLight = 40
    @@maxLight = 90
    avgLight = (@@maxLight + @@minLight) / 2
    deltaLight = @@maxLight - @@minLight
    l = l.clamp(@@minLight, @@maxLight)

    golden_ratio_hues = []

    hue_shift = rand(90)
    hue_rotations = (count * 2 + 1).times.to_a.slice(1..).sample(count)
    count.round.times.each { |i| golden_ratio_hues << ((((h + @@phi * hue_rotations[i]) % 1) * 360) + hue_shift) % 360 }
    golden_ratio_hues.map! { |h| h = (h - 60).abs < 20 ? h + rand(20..40) * (rand(2) > 0 ? 1 : -1) : h }
    golden_ratio_hues.sort!

    hsl_colors = golden_ratio_hues.map { |h| [h, s, l] }
    hsl_inverse = golden_ratio_hues.map { |h| [(h + 180) % 360, s, 120 - l] }
    combined_hsl = hsl_colors.push(*hsl_inverse).sort_by { |hsl| hsl[0] }
    filtered_hsl =
      combined_hsl.map!.with_index do |hsl, i|
        if !(combined_hsl.length == i + 1 || (hsl[0] - combined_hsl[i + 1][0]).abs > 30)
          # rand(2) > 0 ?  : hsl[2] *= rand(0.75..1.25)
          hsl[2] = (combined_hsl[i + 1][2] * rand(0.75..1.25)).clamp(@@minLight, @@maxLight)
        end
        hsl
      end
    sorted_hsl = filtered_hsl.sample(count).sort_by { |hsl| hsl[0] }
    # binding.pry
    combined_palette = sorted_hsl.map { |hsl| hsl_to_hex(*hsl) }
    # binding.pry

    return combined_palette
  end
end
