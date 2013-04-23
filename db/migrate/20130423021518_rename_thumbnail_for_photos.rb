class RenameThumbnailForPhotos < ActiveRecord::Migration
  def up
  	rename_column :photos, :thumnail_image_url, :thumbnail_image_url
  end

  def down
		rename_column :photos, :thumbnail_image_url, :thumnail_image_url
  end
end
