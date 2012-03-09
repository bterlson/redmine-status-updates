ActionController::Routing::Routes.draw do |map|

  map.resources :statuses, :collection => {
    :search => [ :get, :post ],
    :tagged => :get,
    :tag_cloud => :get,
    :find_project => :get,
    :project => :get,
    :find_tag => :get
  }
  map.connect 'status_notifications/edit', :controller => :status_notifications, :action => :edit
  map.connect 'status_notifications/update', :controller => :status_notifications, :action => :update

end
