class Comment < ActiveRecord::Base
  attr_accessible :comment, :comment_date, :instagram_user_id, :comment_id
  belongs_to :photo
  
end
