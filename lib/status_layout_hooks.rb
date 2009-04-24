class StatusProjectHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    return stylesheet_link_tag("redmine_status.css", :plugin => "redmine_status")
  end
end
