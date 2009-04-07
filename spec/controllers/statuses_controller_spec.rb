require File.dirname(__FILE__) + '/../spec_helper'

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
