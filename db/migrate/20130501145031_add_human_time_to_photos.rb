class AddHumanTimeToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :photo_taken_at_time, :string
  end
end
