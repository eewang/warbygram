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

  def self.save_tagged_photos
    photos = InstagramWrapper.new.tag_recent_media({:tag => 'warbyparker'})
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
      photo.tags.each do |tag|
        t = Tag.new
        t.name = tag
        t.save
        p.tags << t
      end      
      photo.comments.data.each do |comment|
        c = Comment.where(:comment_id => comment.id).first_or_create
        c.comment = comment.text
        c.comment_id = comment.id
        c.save
        p.comments << c
      end
      if photo.location
        p.location = photo.location.name
        p.latitude = photo.location.latitude
        p.longitude = photo.location.longitude
      end
      p.save
    end
  end

end
