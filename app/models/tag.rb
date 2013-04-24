class Tag < ActiveRecord::Base
  attr_accessible :photos_user
  belongs_to :photo

end
