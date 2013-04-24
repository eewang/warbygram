class Comment < ActiveRecord::Base
  attr_accessible :comment, :comment_date, :instagram_user_id, :comment_id
  belongs_to :photo
  belongs_to :instagram_user
  
  include Saveable::InstanceMethods

end
