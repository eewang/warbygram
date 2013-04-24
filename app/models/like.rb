class Like < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :instagram_user
  belongs_to :photo
end
