# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
palette_count = 10
colors_per_palette = 5

# Generate random palettes and add random colors to them
palette_count.times.each do |i|
  new_palette = Palette.create(name: Faker::Marketing.buzzwords.titleize)
  new_palette.colors.push(*PalettesController.helpers.color_palettes_for(Faker::Color.hex_color, colors_per_palette).map { |hex| Color.where(hex: hex).first_or_create })
end
