class Photo < ActiveRecord::Base
  attr_accessible :caption, :location, :user_name, :image, :latitude, :longitude, :instagram_id

  def self.save_instagram_popular_photos
    photos = InstagramWrapper.new.media_popular({})
    photos.each do |photo|
      p = Photo.where(:instagram_id => photo["id"]).first_or_create
      p.user_name = photo["user"]["username"]
      p.caption = photo["caption"]["text"] if photo["caption"]
      p.image = photo["images"]["standard_resolution"]["url"]
      p.instagram_id = photo["id"]
      if photo.location
        p.location = photo["location"]["name"]
        p.latitude = photo["location"]["latitude"]
        p.longitude = photo["location"]["longitude"]
      end
      p.save
    end
  end

end
