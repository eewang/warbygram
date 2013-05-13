class CreateGlassesColors < ActiveRecord::Migration
  def change
    create_table :glasses_colors do |t|
      t.references :color
      t.references :glasses

      t.timestamps
    end
    add_index :glasses_colors, :color_id
    add_index :glasses_colors, :glasses_id
  end
end
