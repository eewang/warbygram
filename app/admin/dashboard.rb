ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    columns do

      column do
        panel "Tag chart" do
          div do
            render('/admin/sidebar_links', :model => 'Glasses')
          end
        end
      end


    end # columns

    columns do

      column do
        panel "Last 10 Frame Styles Recently Updated" do
          table_for Glasses.order('updated_at desc').limit(10) do
            column("Styles")     {|glasses| link_to(glasses.name, admin_glass_path(glasses)) } 
            column("Collection")   {|glasses| glasses.collection } 
          end
        end
      end

      column do
        panel "Most Popular Instagram Tags" do
          table_for WarbyTag.order('count desc').limit(10) do
            column("Tags")    {|warby_tags| link_to(warby_tags.tag, admin_warby_tag_path(warby_tags)) }
            column("Number of Tags")    {|warby_tags| number_with_delimiter(warby_tags.count)               }
          end
        end
      end

      column do
        panel "new column"
      end

    end # columns

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
