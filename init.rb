# Redmine status updates plugin
require 'redmine'

require 'dispatcher'
require 'status_user_patch'

Dispatcher.to_prepare do
  User.send(:include, ::Plugin::Status::User)
end

Redmine::Plugin.register :status do
  name 'Redmine Status Updates'
  author 'Brian Terlson'
  description 'Allow users to add small status updates about what they are working on or finished or what-have-you.'
  version '0.1.0'
  
  project_module :statuses do
    permission :view_statuses, {:statuses => [:index, :tagged, :tag_cloud], :status_notifications => [:edit]}
    permission :create_statuses, {:statuses => [:new, :create]}
  end
 
  menu :top_menu, "Status Updates", :controller => 'statuses', :action => 'index'
  menu :project_menu, "Status Updates", :controller => 'statuses', :action => 'index'
end
