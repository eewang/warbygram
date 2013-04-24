class Tag < ActiveRecord::Base
  attr_accessible :photos_user, :photo_id, :name

  has_many :photo_tags
  has_many :photos, :through => :photo_tags



end
