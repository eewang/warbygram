class Tag < ActiveRecord::Base
  attr_accessible :photos_user
  has_many :photo_tags
  has_many :photos, :through => :photo_tags


end
