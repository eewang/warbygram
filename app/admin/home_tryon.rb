ActiveAdmin.register_page "Home Try On" do

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do

      column do 
        panel "Home Try On" do
          div do
            render :text => "testing"     
          end # div
        end # panel
      end # column
    end # columns

  end # content

  
end