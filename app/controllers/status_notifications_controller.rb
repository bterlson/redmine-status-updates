class StatusNotificationsController < ApplicationController
  unloadable
  layout 'base'
  before_filter :authorize

  helper :statuses
  
  def edit
    @notification = User.current.status_notification
  end
  
  private

  # Authorize the user for the requested action
  # Hack of the core authorize to do a global check
  def authorize(ctrl = params[:controller], action = params[:action])
    allowed = User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
    allowed ? true : deny_access
  end
end
