class Photo < ActiveRecord::Base
  attr_accessible :caption, :location, :user_name, :std_res_image_url, :low_res_image_url, :thumbnail_image_url, :latitude, :longitude, :instagram_id
  has_many :photo_tags
  has_many :tags, :through => :photo_tags
  has_many :comments
  has_many :likes
  belongs_to :instagram_user

  include Saveable::InstanceMethods

  WARBY_TAGS = ["warby", "warbyparker"]

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
      p.caption = photo.caption.text if photo.caption
      p.std_res_image_url = photo.images.standard_resolution.url
      p.low_res_image_url = photo.images.low_resolution.url
      p.thumbnail_image_url = photo.images.thumbnail.url      
      p.instagram_id = photo.id
      p.filter = photo.filter
      p.created_time = photo.created_time
      p.link = photo.link
      p.save_tags(photo)
      p.save_comments(photo)
      p.save_location(photo)
      p.save_user(photo)
      p.save_likes(photo)
      p.save
    end
  end

  def self.get_warby_tag_metadata
    WARBY_TAGS.each do |tag|
      tag_results = InstagramWrapper.new.tag_search(:tag => tag)
      tag_results.each do |tag_result|
        item = WarbyTag.where(:tag => tag_result[:name]).first_or_create
        item.count = tag_result[:media_count]
        item.save
      end
    end
  end

  def self.save_warby_tagged_photos(tag_array)
    tag_array.each do |tag_result|
      Photo.save_tagged_photos(tag_result[:name])
    end
  end

  def save_tags(instagram_photo)
    instagram_photo.tags.each do |tag|
      t = Tag.where(:name => tag).first_or_create
      self.photo_tags.build(:tag_id => t.id)
      t.photo_id = self.id
      t.save
      self.save
    end 
  end

  def save_comments(instagram_photo)
    instagram_photo.comments.data.each do |comment|
      c = Comment.where(:comment_id => comment.id).first_or_create
      c.comment = comment.text
      c.comment_id = comment.id
      c.photo_id = self.id
      c.comment_date = comment.created_time
      c.save_user(comment)
      c.save
    end
  end

  def save_likes(instagram_photo)
    instagram_photo.likes.data.each do |like|
      l = Like.new
      l.photo_id = self.id
      l.save_user(like)
      l.save
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
