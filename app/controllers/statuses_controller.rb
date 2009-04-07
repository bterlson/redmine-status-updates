class StatusesController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project, :authorize

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

  private
  
  def find_project
    @project=Project.find(params[:id])
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
