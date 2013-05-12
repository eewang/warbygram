module PhotosHelper

  def get_user_photos(user_photo_set)
    user_photos = user_photo_set.collect do |p|
      photo = Photo.find(p)
      [photo.thumbnail_image_url, photo.link]
    end  
  end

end
