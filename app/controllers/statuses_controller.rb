class StatusesController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project, :authorize
  
  # Print a list of all the developer statuses.
  # TODO: Pagination, xml/json feeds.
  def index
    statuses = Status.find_all_by_project_id(@project.id, :order => "created_at DESC", :limit => 100)
    
    @statuses_by_day = statuses.group_by{|s| s.created_at.at_beginning_of_day}
    
    # Get the days in reverse order that statuses take place on.
    @status_days = @statuses_by_day.keys.sort.reverse
    
  end
  
  
  def new
    
  end
  
  # Create a new status.
  # TODO: Accept XML data.
  
  def create
    @status = Status.new(params[:status])
    @status.user_id = User.current.id
    @status.project_id = @project.id
    @status.save
    
    redirect_to :back
  end
  
  private
  
  def find_project
    @project=Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
