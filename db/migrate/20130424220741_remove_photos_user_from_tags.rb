class RemovePhotosUserFromTags < ActiveRecord::Migration
  def change
    remove_column :tags, :photos_user
  end
end
