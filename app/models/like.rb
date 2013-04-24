class Like < ActiveRecord::Base
  attr_accessible :photo_id, :instagram_user_id
  belongs_to :instagram_user
  belongs_to :photo

  include Saveable::InstanceMethods
  
end
