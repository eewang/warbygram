ActiveAdmin.register_page "Photo Feed" do

  menu :parent => "Real Time Feed"

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do

      column do 
        panel "Photo Feed" do
          div do
            render(:partial => '/admin/photo_feed', :locals => { :photos => Photo.photo_feed(25) })
          end # div
        end # panel
      end # column
    end # columns

  end # content

end