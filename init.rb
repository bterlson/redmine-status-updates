# Redmine status updates plugin
require 'redmine'

Redmine::Plugin.register :status do
  name 'Redmine Status Updates'
  author 'Brian Terlson'
  description 'Allow users to add small status updates about what they are working on or finished or what-have-you.'
  version '0.1.0'
  
  project_module :statuses do
    permission :view_statuses, {:statuses => [:index, :tagged]}
    permission :create_statuses, {:statuses => [:new, :create]}
  end
 
  menu :project_menu, "Status Updates", :controller => 'statuses', :action => 'index'
end
