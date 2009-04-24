require File.dirname(__FILE__) + '/../spec_helper'

describe StatusProjectHooks, "#view_projects_show_left", :type => :view do
  include Redmine::Hook::Helper
  include ActionView::Helpers::UrlHelper
  include ActionController::UrlWriter

  before(:each) do
    @project = mock_model(Project, :module_enabled? => true)
    @context = { :project => @project }

    @current_user = mock_model(User, :name => 'Test', :admin? => false, :logged? => true, :language => :en, :allowed_to? => true, :time_zone => nil)
    User.stub!(:current).and_return(@current_user)

    Status.stub!(:recent_updates_for).and_return([])
    # Hack to make RSpec play nicely with call_hook's default contexts
    self.stub!(:controller).and_return(@controller)
  end

  it "should do nothing if the Status module isn't active" do
    @project.should_receive(:module_enabled?).with(:statuses).and_return(nil)
    response = call_hook(:view_projects_show_left, @context)
    response.should be_empty
  end

  it "should do nothing if the user doesn't have permission to view_statuses" do
    StatusProjectHooks.instance.should_receive(:authorize_for).with('statuses', 'index').and_return(false)
    response = call_hook(:view_projects_show_left, @context)
    response.should be_empty
  end

  describe 'with the Status module enabled and a valid user' do
    it 'should render a box div' do
      response = call_hook(:view_projects_show_left, @context)
      response.should have_tag('div.box#statuses')
    end

    it 'should render the latest 5 statuses' do
      Status.should_receive(:recent_updates_for).with(@project, 5).and_return do
        r = []
        5.times do |i|
          r << Status.new(:user => @current_user, :message => "Message #{i}")
        end
        r
      end

      response = call_hook(:view_projects_show_left, @context)
      response.should have_tag("div.box#statuses") do
        with_tag("dd.status_message", :count => 5)
      end
    end

    it 'should link to view all statuses' do
      response = call_hook(:view_projects_show_left, @context)
      response.should have_tag('a[href=?]',
                               url_for(:controller => 'statuses',
                                       :action => 'index',
                                       :id => @project.id,
                                       :only_path => true),
                               'View all statuses')
    end

  end
end

