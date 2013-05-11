ActiveAdmin.register_page "Photo Map" do

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do

      column do 
        panel "Photo Map" do
          div do
            render(:partial => '/admin/photo_map', :locals => 
              {:start_center => Geocoder.coordinates("188 Suffolk Street, New York NY"),
              :map_data => Photo.get_photos_with_location}
              )          
          end # div
        end # panel
      end # column
    end # columns

  end # content

  
end