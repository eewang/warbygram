class InstagramUser < ActiveRecord::Base
  attr_accessible :user_name, :full_name, :profile_picture, :uid
  has_many :likes
  has_many :photos
  has_many :comments
end
