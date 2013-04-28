class AddColumnsToGlasses < ActiveRecord::Migration
  def change
    add_column :glasses, :style, :string
    add_column :glasses, :color, :string
    add_column :glasses, :collection, :string
    add_column :glasses, :optical, :boolean
    add_column :glasses, :sku, :string
    add_column :glasses, :active, :boolean
  end
end
