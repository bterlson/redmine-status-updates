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
    @status.project_id = check_project_id(@status)
    @status.save
    
    redirect_to :action => 'index', :id => project
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

  # Check the project ids when creating a new status to make sure that
  # either:
  #
  # * current project is set
  # * user has permission to create_statuses on the project_id parameter
  def check_project_id(status)
    if project
      if User.current.allowed_to?(:create_statuses, project)
        return project.id
      end
    elsif params[:status] && params[:status][:project_id]
      project_id = params[:status][:project_id]
      if User.current.allowed_to?(:create_statuses, Project.find(project_id))
        return project_id
      end
    else
      return nil
    end
  end

  def find_tag
    @tag = params[:tag]
  end
end
