require File.dirname(__FILE__) + '/../spec_helper'

describe StatusNotificationsController, "routing" do
  
end


describe StatusNotificationsController, "#edit" do
  before(:each) do
    @notification = mock_model(StatusNotification)
    @current_user = mock_model(User, :admin? => false, :logged? => true, :language => :en, :allowed_to? => true, :status_notification => @notification)
    User.stub!(:current).and_return(@current_user)
  end

  it 'should be found at /status_notifications/edit' do
    route_for(:controller => 'status_notifications', :action => 'edit').should == '/status_notifications/edit'
  end

  it 'should be successful' do
    get :edit
    response.should be_success
  end

  it 'should setup the notification for the template' do
    get :edit
    assigns[:notification].should_not be_nil
  end

  it 'should render the edit template' do
    get :edit
    response.should render_template('edit')
  end

end

describe StatusNotificationsController, "#update" do
end
