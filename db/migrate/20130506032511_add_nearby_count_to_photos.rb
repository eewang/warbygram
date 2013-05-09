class AddNearbyCountToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :nearby_count, :integer
  end
end
