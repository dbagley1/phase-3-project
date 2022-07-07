class CreateColorTagJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :colors, :tags do |t|
      # t.index [:color_id, :tag_id]
      # t.index [:tag_id, :color_id]
    end
  end
end
