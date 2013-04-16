class AddColumnsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :image, :string
    add_column :photos, :latitude, :string
    add_column :photos, :longitude, :string
    rename_column :photos, :title, :caption
    rename_column :photos, :person, :user_name
  end
end
