module Saveable

  module InstanceMethods

    def test
      puts "Hello Erin"
    end

    def save_user(instagram_object)
      if self.class == Photo
        photo_user = instagram_object.user # => single user
        instagram_user = InstagramUser.where(:uid => photo_user.id).first_or_create
        instagram_user.user_name = photo_user.username
        instagram_user.full_name = photo_user.full_name
        instagram_user.profile_picture = photo_user.profile_picture
        instagram_user.save
        self.instagram_user_id = instagram_user.id
        self.save
      elsif self.class == Comment
        comment_user = instagram_object.from # => array of users
        instagram_user = InstagramUser.where(:uid => comment_user.id).first_or_create
        instagram_user.user_name = comment_user.username
        instagram_user.full_name = comment_user.full_name
        instagram_user.profile_picture = comment_user.profile_picture
        instagram_user.save
        self.instagram_user_id = instagram_user.id
        self.save
      elsif self.class == Like
        like_user = instagram_object
        instagram_user = InstagramUser.where(:uid => like_user.id).first_or_create
        instagram_user.user_name = like_user.username
        instagram_user.full_name = like_user.full_name
        instagram_user.profile_picture = like_user.profile_picture
        instagram_user.save
        self.instagram_user_id = instagram_user.id
        self.save
      end

      # def self.save_user(*models)
      #   models.each do |model|
      #     define_method "#{model}_save_user" do 

      #     end
      #   end
      # end

      # save_user :photo, :comment, :like

    end

  end

end