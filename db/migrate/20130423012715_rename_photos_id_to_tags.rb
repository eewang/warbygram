class RenamePhotosIdToTags < ActiveRecord::Migration
  def up
  	rename_column :tags, :photos_id, :photo_id
  end

  def down
  	rename_column :tags, :photo_id, :photos_id
  end
end
