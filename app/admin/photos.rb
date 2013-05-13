ActiveAdmin.register Photo do

  menu :parent => "Data Tables", :priority => 20

  config.sort_order = "photo_taken_at_time_desc"
  scope :all

  index do
    column "Photo Id", :id
    column :caption
    column :instagram_user_id do |photo|
      user = InstagramUser.find(photo.instagram_user_id)
      link_to(user.user_name, "http://instagram.com/#{user.user_name}", :target => "_blank")
    end
    column :photo_taken_at_time
    column :tags do |photo|
      photo.tags.collect { |t| t.name }.uniq.join("; ")
    end
    column "Photo Link", :link do |photo|
      link_to(photo.link, photo.link, :target => "_blank")
    end
    default_actions
  end  
end