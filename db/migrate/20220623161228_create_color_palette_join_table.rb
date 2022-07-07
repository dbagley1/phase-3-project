class CreateColorPaletteJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :colors, :palettes do |t|
      # t.index [:color_id, :palette_id]
      # t.index [:palette_id, :color_id]
    end
  end
end
