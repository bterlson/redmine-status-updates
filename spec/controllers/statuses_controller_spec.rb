require File.dirname(__FILE__) + '/../spec_helper'

describe StatusesController, "#index" do
  before(:each) do
    @current_user = mock_model(User, :admin? => false, :logged? => true, :language => :en, :allowed_to? => true)
    User.stub!(:current).and_return(@current_user)

    @project = mock_model(Project, :identifier => 'test-project', :id => 42)
    controller.stub!(:find_project).and_return(@project)
    controller.stub!(:project).and_return(@project)
  end
  
  it "should be successful" do
    get :index, :id => @project.id
    response.should be_success
  end

  it "should render the index template" do
    get :index, :id => @project.id
    response.should render_template('index')
  end

  it "should assign Statuses for the project" do
    statuses = []
    5.times do
      statuses << mock_model(Status)
    end
    Status.should_receive(:recent_updates_for).with(@project).and_return(statuses)

    get :index, :id => @project.id
    assigns[:statuses].should eql(statuses)
  end


end

describe StatusesController, "#tagged" do
  before(:each) do
    @current_user = mock_model(User, :admin? => false, :logged? => true, :language => :en, :allowed_to? => true)
    User.stub!(:current).and_return(@current_user)

    @project = mock_model(Project, :identifier => 'test-project', :id => 42)
    controller.stub!(:find_project).and_return(@project)
    controller.stub!(:project).and_return(@project)
  end
  
  it "should be successful" do
    get :tagged, :id => @project.id, :tag => "test"
    response.should be_success
  end

  it "should render the tagged template" do
    get :tagged, :id => @project.id, :tag => "test"
    response.should render_template('tagged')
  end

  it "should assign Statuses for the project matching the tag" do
    statuses = []
    5.times do
      statuses << mock_model(Status, :message => "This is a #test")
    end
    Status.should_receive(:recently_tagged_with).with('test', @project).and_return(statuses)

    get :tagged, :id => @project.id, :tag => "test"
    assigns[:statuses].should eql(statuses)
  end

end

describe StatusesController, "#tag_cloud" do
  before(:each) do
    @current_user = mock_model(User, :admin? => false, :logged? => true, :language => :en, :allowed_to? => true)
    User.stub!(:current).and_return(@current_user)

    @project = mock_model(Project, :identifier => 'test-project', :id => 42)
    controller.stub!(:find_project).and_return(@project)
    controller.stub!(:project).and_return(@project)
    Status.stub!(:tag_cloud)
  end
  
  it "should be successful" do
    get :tag_cloud, :id => @project.id
    response.should be_success
  end

  it "should render the tag_cloud template" do
    get :tag_cloud, :id => @project.id
    response.should render_template('tag_cloud')
  end

  it 'should assign the tags for the view' do
    Status.should_receive(:tag_cloud).and_return([])
    get :tag_cloud, :id => @project.id
    assigns[:tags].should_not be_nil
  end
end
