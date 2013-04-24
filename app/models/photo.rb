class Photo < ActiveRecord::Base
  attr_accessible :caption, :location, :user_name, :std_res_image_url, :low_res_image_url, :thumbnail_image_url, :latitude, :longitude, :instagram_id
  has_many :tags
  has_many :comments

  def self.save_instagram_popular_photos
    photos = InstagramWrapper.new.media_popular({})
    photos.each do |photo|
      p = Photo.where(:instagram_id => photo.id).first_or_create
      p.user_name = photo.user.username
      p.caption = photo.caption.text if photo.caption
      p.std_res_image_url = photo.images.standard_resolution.url
      p.low_res_image_url = photo.images.low_resolution.url
      p.thumbnail_image_url = photo.images.thumbnail.url      
      p.instagram_id = photo.id
      p.filter = photo.filter
      p.created_time = photo.created_time
      p.link = photo.link
      if photo.location
        p.location = photo.location.name
        p.latitude = photo.location.latitude
        p.longitude = photo.location.longitude
      end
      p.save
    end
  end

  def self.save_tagged_photos(instagram_tag)
    photos = InstagramWrapper.new.tag_recent_media({:tag => instagram_tag})
    photos.each do |photo|
      # Creating a photo and associating the Instagram image properties
      p = Photo.where(:instagram_id => photo.id).first_or_create
      p.user_name = photo.user.username
      p.caption = photo.caption.text if photo.caption
      p.std_res_image_url = photo.images.standard_resolution.url
      p.low_res_image_url = photo.images.low_resolution.url
      p.thumbnail_image_url = photo.images.thumbnail.url      
      p.instagram_id = photo.id
      p.filter = photo.filter
      p.created_time = photo.created_time
      p.link = photo.link

      # Saving tags
      p.save_tags(photo)

      # Saving comments  
      p.save_comments(photo)

      # Saving location
      p.save_location(photo)

      p.save
    end
  end

  def save_tags(instagram_photo)
    instagram_photo.tags.each do |tag|
      t = Tag.new
      t.name = tag
      t.save
      self.tags << t
    end 
  end

  def save_comments(instagram_photo)
    instagram_photo.comments.data.each do |comment|
      c = Comment.where(:comment_id => comment.id).first_or_create
      c.comment = comment.text
      c.comment_id = comment.id
      c.save
      self.comments << c
    end
  end

  def save_location(instagram_photo)
    if instagram_photo.location
      self.location = instagram_photo.location.name
      self.latitude = instagram_photo.location.latitude
      self.longitude = instagram_photo.location.longitude
    end
  end

end
