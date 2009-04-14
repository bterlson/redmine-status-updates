class StatusNotificationsController < ApplicationController
  unloadable
  layout 'base'
  before_filter :authorize

  helper :statuses
  
  def edit
    @notification = User.current.status_notification
  end

  def update
    @notification = User.current.status_notification
    @notification ||= User.current.build_status_notification

    @notification.option = params[:status_notification][:option] if params[:status_notification]
    if @notification.save
      flash[:notice] = "Preferences saved as #{@notification.option_to_string}."
      redirect_to :controller => 'status_notifications', :action => 'edit'
    else
      flash[:error] = 'Could not save your preference.  Please try again'
      render :action => 'edit'
    end
  end
  
  private

  # Authorize the user for the requested action
  # Hack of the core authorize to do a global check
  def authorize(ctrl = params[:controller], action = params[:action])
    allowed = User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
    allowed ? true : deny_access
  end
end
