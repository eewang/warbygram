class AddDetailsToPhotos < ActiveRecord::Migration
  def change
  	add_column :photos, :std_res_image_url, :string
  	add_column :photos, :thumnail_image_url, :string
  	add_column :photos, :filter, :string
  	add_column :photos, :created_time, :string
  	add_column :photos, :link, :string

  	rename_column :photos, :image, :low_res_image_url
  end
end
