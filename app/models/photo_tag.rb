class PhotoTag < ActiveRecord::Base
  attr_accessible :photo_id, :tag_id
  belongs_to :tag
  belongs_to :photo

end
