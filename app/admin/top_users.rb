ActiveAdmin.register_page "Top Users" do

  menu :parent => "Data Analytics"

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do

      column do 
        panel "Top Users" do
          div do
            render(:partial => "/admin/top_users", :locals => { :@users => Photo.top_users(3) })    
          end # div
        end # panel
      end # column

    end # columns

  end # content

  
end