class Comment < ActiveRecord::Base
  attr_accessible :comment, :comment_date, :instagram_user_id, :comment_id
  belongs_to :photo
  belongs_to :instagram_user
  
  include Saveable::InstanceMethods

  def self.search(query)
    regexp = /#{query}/i
    results = Comment.all.collect { |comment|
      if comment.comment =~ regexp
        {:photo_id => comment.photo_id, :comment => comment.comment}
      end
      }.delete_if { |i| i.nil? }
  end

  def search_for_warby
    comment =~ /@warby/ && comment !~ /#warby/
  end

  def self.search_photo_comments_for_warby(photo_id)
    Photo.find(photo_id).comments.collect { |comment| comment.search_for_warby }.delete_if { |i| i.nil? }
  end

end
