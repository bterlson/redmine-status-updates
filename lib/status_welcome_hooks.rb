class StatusWelcomeHooks < Redmine::Hook::ViewListener
  include GravatarHelper::PublicMethods
  include StatusesHelper

  def view_welcome_index_left(context = {})
    html = '<div class="box" id="statuses">'
    html += '<h3 class="icon22 icon22-users">Developer Status</h3>'

    Status.recent_updates_for(nil, 5).each do |status|
      html += <<EOHTML
            <div>
              <dl>
                <dt class="status_user">#{ avatar(status.user) }#{h status.user.name} #{ format_project(status) }</dt>
                <dd class="status_message">
                  <span class="time">#{format_time(status.created_at, true)}:</span>
                  <p>#{format_status_message(status)}</p>
                </dd>
              </dl>
            </div>
            <div style="clear:both;"></div>
EOHTML
    end
    html += link_to("View all statuses", :controller => 'statuses', :action => 'index')
    html += '</div>'

    return html
  end
end
