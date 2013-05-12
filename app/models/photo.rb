class Photo < ActiveRecord::Base
  attr_accessible :caption, :location, :user_name, :std_res_image_url, :low_res_image_url, :thumbnail_image_url, :latitude, :longitude, :instagram_id, :address

  has_many :photo_tags
  has_many :tags, :through => :photo_tags
  has_many :comments
  has_many :likes
  belongs_to :instagram_user

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  @@nearby_photos = []

  class << self
    attr_accessor :nearby_photos
  end

  include Saveable::InstanceMethods

  WARBY_TAGS = ["warby", "warbyparker"]

  EXCLUDED_TAGS = ["warbyrange", "warbyranges", "warbyticarmo"]

  WARBY_LOCATIONS = [
    "121 Greene Street, New York NY",
    "295 Lafayette Street, New York NY",
    "4661 Hollywood Boulevard, Los Angeles CA",
    "550 South Flower Street, Los Angeles CA",
    "728 Divisadero Street, San Francisco CA",
    "116 N 3rd Street, Philadelphia PA",
    "3 NW 9th Street, Oklahoma City OK",
    "1804 N Damen Avenue, Chicago IL",
    "40 Island Avenue, Miami FL",
    "79 Cannon Street, Charleston SC",
    "2601 12th Avenue South, Nashville TN",
    "3100 West Cary Street, Richmond VA"
  ]

  def self.photo_feed(number)
    set = Photo.order("photo_taken_at_time DESC")[0..number-1]
    photo_feed = set.collect do |item|
      photo = { :caption => item.caption,
        :photo => item.low_res_image_url,
        :photo_taken_at_time => item.photo_taken_at_time,
        :photo_link => item.link,
        :user => InstagramUser.find(item.instagram_user_id).user_name
        }
      if item.comments.present?
        photo[:comments] ||= []
        item.comments.each do |i|
          photo[:comments] << {:user => InstagramUser.find(i.instagram_user_id).user_name, :comment => i.comment }
        end
      end
      photo
    end
  end

  def self.check_location(lat, lon, dis)
    i_photos = InstagramWrapper.new.media_search(
      {:lat => lat, :lon => lon, :distance => dis, 
      :min_timestamp => 60.minutes.ago.to_i, :max_timestamp => Time.now.to_i})
    i_photos.collect! do |i_p| 
      if !i_p.caption.nil? && i_p.caption.text =~ /@warby/ && i_p.caption.text !~ /#warby/
        i_p
      end
    end
    i_photos.compact!
    if i_photos.present?
      i_photos.each do |photo|
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
        p.convert_unix_time
        p.save
        if p.latitude
          near_coordinates([p.latitude, p.longitude], 5).each do |photo|
            Photo.find(photo[:photo]).nearby_count += 1
          end
        end
      end
    end
  end

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
      p.convert_unix_time
      p.save
      if p.latitude
        near_coordinates([p.latitude, p.longitude], 5).each do |photo|
          Photo.find(photo[:photo]).nearby_count += 1
        end
      end
    end
  end

  def self.get_warby_tag_metadata
    WARBY_TAGS.each do |tag|
      tag_results = InstagramWrapper.new.tag_search(:tag => tag)
      tag_results.reject! { |h| EXCLUDED_TAGS.include?(h["name"]) }
      tag_results.each do |tag_result|
        item = WarbyTag.where(:tag => tag_result[:name]).first_or_create
        item.count = tag_result[:media_count]
        item.save
      end
    end
  end

  def self.save_warby_tagged_photos
    WarbyTag.all.reject! { |t| EXCLUDED_TAGS.include?(t.tag) }.each do |warby_tag|
      Photo.save_tagged_photos(warby_tag.tag)
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
      self.nearby_count = Photo.near_coordinates([instagram_photo.location.latitude, instagram_photo.location.longitude], 5).size
    end
  end

  def address
    Geocoder.search([self.latitude, self.longitude])[0].address if self.latitude
  end

  def self.geotagged
    Photo.all.collect { |photo| photo unless photo.latitude.nil? }.delete_if { |item| item.nil? }
  end

  def self.caption_search(query)
    regexp = /##{query}\s/i
    results = Photo.all.collect { |photo|
      if photo.caption =~ regexp
        {:photo_id => photo.id, :caption => photo.caption}
      end
      }.compact!
  end

  def convert_unix_time
    self.photo_taken_at_time = DateTime.strptime(self.created_time, '%s')
  end

  def self.get_photos_with_location
    Photo.all.collect { |item|
      if item.latitude && item.longitude
        {:photo => item.id, :latitude => item.latitude, :longitude => item.longitude}
      end
    }.compact!
  end

  def self.near_coordinates(coordinates, distance) # distance should be 5 km
    photos_array = get_photos_with_location.collect do |photo|
      if Photo.find(photo[:photo]).distance_to(coordinates, :units => :km) <= distance
        photo
      end
    end
    photos_array.compact!
  end

  def nearby_photo_count
    latitude ? Photo.near_coordinates([latitude, longitude], 5).size : 0
  end

  def self.set_nearby_photo_count
    get_photos_with_location.collect do |photo|
      photo_update = Photo.find(photo[:photo])
      photo_update.nearby_count = photo_update.nearby_photo_count
      photo_update.save
    end
  end

  def self.check_warby_reference
    photos = Photo.all.collect { |photo|
      if photo.caption =~ /@warby/ && photo.caption !~ /#warby/
        photo
      end
    }.compact!
  end

  def self.top_users(min_count)
    get_top_users = group(:instagram_user_id).size.sort_by { |h| h[1] }.delete_if { |i| i[1] < min_count }.reverse
    get_top_users.collect! do |user|
      instagram_user = InstagramUser.find(user[0].to_i)
      { :user_name => instagram_user.user_name,
        :full_name => instagram_user.full_name,
        :profile_pic => instagram_user.profile_picture,
        :profile => "http://instagram.com/#{instagram_user.user_name}",
        :photos_taken => user[1],
        :photos => Photo.where(:instagram_user_id => user[0].to_i).collect { |p| p.id }
      }
    end
  end

end
