class CreatePaletteTagJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :palettes, :tags do |t|
      # t.index [:palette_id, :tag_id]
      # t.index [:tag_id, :palette_id]
    end
  end
end
