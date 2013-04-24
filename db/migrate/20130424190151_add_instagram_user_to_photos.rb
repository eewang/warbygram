class AddInstagramUserToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :instagram_user_id, :string
    remove_column :photos, :user_name
  end
end
