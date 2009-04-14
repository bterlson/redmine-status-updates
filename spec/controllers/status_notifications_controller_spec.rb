require File.dirname(__FILE__) + '/../spec_helper'

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
  before(:each) do
    @notification = mock_model(StatusNotification, :option= => nil, :option => nil)
    @current_user = mock_model(User, :admin? => false, :logged? => true, :language => :en, :allowed_to? => true, :status_notification => @notification)
    User.stub!(:current).and_return(@current_user)
  end

  it 'should be found at /status_notifications/update' do
    route_for(:controller => 'status_notifications', :action => 'update').should == '/status_notifications/update'
  end

  describe 'when successfully saved' do
    before(:each) do
      @notification.stub!(:save).and_return(true)
      @notification.stub!(:option_to_string).and_return('Hourly')
    end

    it 'should redirect to edit' do
      post :update, :system_notification => {:option => 'hourly'}
      response.should be_redirect
      response.should redirect_to(:controller => 'status_notifications', :action => 'edit')
    end

    it 'should display a flash message' do
      post :update, :system_notification => {:option => 'hourly'}
      flash[:notice].should include('Preferences saved')
    end

    it 'should display the saved option in the flash message' do
      post :update, :system_notification => {:option => 'hourly'}
      flash[:notice].should include('Hourly')
    end
  end

  describe 'when unsuccessfully saved' do
    before(:each) do
      @notification.stub!(:save).and_return(false)
    end

    it 'should render the edit template' do
      post :update, :system_notification => {:option => 'hourly'}
      response.should render_template('edit')
    end

    it 'should setup the notification for the template' do
      post :update, :system_notification => {:option => 'hourly'}
      assigns[:notification].should_not be_nil
    end

    it 'should display a flash message' do
      post :update, :system_notification => {:option => 'hourly'}
      flash[:error].should eql('Could not save your preference.  Please try again')
    end
  end
end
