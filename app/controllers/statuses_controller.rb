class StatusesController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project

  before_filter :find_tag, :only => [:tagged]

  # Print a list of all the developer statuses.
  # TODO: Pagination, xml/json feeds.
  def index
    @statuses = Status.recent_updates_for(project)
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


  def tagged
    @statuses = Status.recently_tagged_with(@tag, project)
  end

  def tag_cloud
    @tags = Status.tag_cloud
  end

  private

  # Finds and authorizes the user to the current project
  def find_project
    @project=Project.find(params[:id]) unless params[:id].blank?
    allowed = User.current.allowed_to?({:controller => params[:controller], :action => params[:action]}, @project, :global => true)
    allowed ? true : deny_access
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def project
    @project
  end

  def find_tag
    @tag = params[:tag]
  end
end
