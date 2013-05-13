class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.integer :cc
      t.string :color
      t.string :color_family
      t.string :color_assignment

      t.timestamps
    end
  end
end
