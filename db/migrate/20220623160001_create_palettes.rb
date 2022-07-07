class CreatePalettes < ActiveRecord::Migration[7.0]
  def change
    create_table :palettes do |t|
      t.string :name

      t.timestamps
    end
  end
end
