class AddMaleColumnToGlasses < ActiveRecord::Migration
  def change
    add_column :glasses, :male, :boolean
  end
end
