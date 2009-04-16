require File.dirname(__FILE__) + '/../spec_helper'

describe StatusNotification do
  it 'should have a user association' do
    StatusNotification.should have_association(:user, :belongs_to)
  end
end

describe StatusNotification, '#option_to_string' do
  it 'should return nil if no option is set' do
    StatusNotification.new.option_to_string.should be_nil
  end

  it 'should return nil if no valid option is set' do
    StatusNotification.new(:option => 'fake').option_to_string.should be_nil
  end

  it 'should return the VALID_OPTION value' do
    StatusNotification.new(:option => 'realtime').option_to_string.should eql('Realtime')
  end
end

describe StatusNotification, '#validate' do
  it 'should be valid with one of the VALID_OPTIONS' do
    StatusNotification.new(:option => 'realtime').valid?.should be_true
  end

  it 'should be valid with a blank option' do
    StatusNotification.new(:option => '').valid?.should be_true
  end

  it 'should be valid with a nil option' do
    StatusNotification.new().valid?.should be_true
  end

  it 'should not be valid with a different option' do
    StatusNotification.new(:option => 'fake').valid?.should be_false
  end
end

describe StatusNotification, "#notify with an hourly user" do
  describe 'last notified less than an hour ago' do
    it 'should not send an email' do
      ActionMailer::Base.deliveries.clear
      @user = mock_model(User)
      @status_notification = mock_model(StatusNotification, :user => @user)
      @status_notification.should_receive(:option).and_return('hourly')
      @status_notification.should_receive(:last_updated_at).and_return(Time.now)
      @user.stub!(:status_notification).and_return(@status_notification)
      User.should_receive(:active).and_return([@user])

      StatusNotification.notify
      ActionMailer::Base.deliveries.should be_empty
    end
  end

  describe 'last notified over an hour ago' do
    before(:each) do
      @time = 6.hours.ago
      
      ActionMailer::Base.deliveries.clear
      @user = mock_model(User)
      @status_notification = mock_model(StatusNotification, :user => @user)
      @status_notification.stub!(:option).and_return('hourly')
      @status_notification.stub!(:last_updated_at).and_return(@time)
      @user.stub!(:status_notification).and_return(@status_notification)
      User.stub!(:active).and_return([@user])
      Status.stub!(:since).with(@status_notification.last_updated_at).and_return([])
      StatusMailer.stub!(:deliver_delayed_notification)
    end
    
    it 'should find all the statuses added since the last notification' do
      Status.should_receive(:since).with(@status_notification.last_updated_at).and_return([])
      StatusNotification.notify
    end

    it 'should send a digest email of the notifications' do
      StatusMailer.should_receive(:deliver_delayed_notification).with(@user, [])
      StatusNotification.notify
    end
  end
end

describe StatusNotification, "#notify with an eight hour user" do
  describe 'last notified less than eight hours ago' do
    it 'should not send an email' do
      ActionMailer::Base.deliveries.clear
      @user = mock_model(User)
      @status_notification = mock_model(StatusNotification, :user => @user)
      @status_notification.should_receive(:option).and_return('eight_hours')
      @status_notification.should_receive(:last_updated_at).and_return(Time.now)
      @user.stub!(:status_notification).and_return(@status_notification)
      User.should_receive(:active).and_return([@user])

      StatusNotification.notify
      ActionMailer::Base.deliveries.should be_empty
    end
  end

  describe 'last notified over a eight hours ago' do
    before(:each) do
      @time = 9.hours.ago
      
      ActionMailer::Base.deliveries.clear
      @user = mock_model(User)
      @status_notification = mock_model(StatusNotification, :user => @user)
      @status_notification.stub!(:option).and_return('eight_hours')
      @status_notification.stub!(:last_updated_at).and_return(@time)
      @user.stub!(:status_notification).and_return(@status_notification)
      User.stub!(:active).and_return([@user])
      Status.stub!(:since).with(@status_notification.last_updated_at).and_return([])
      StatusMailer.stub!(:deliver_delayed_notification)
    end
    
    it 'should find all the statuses added since the last notification' do
      Status.should_receive(:since).with(@status_notification.last_updated_at).and_return([])
      StatusNotification.notify
    end

    it 'should send a digest email of the notifications' do
      StatusMailer.should_receive(:deliver_delayed_notification).with(@user, [])
      StatusNotification.notify
    end
  end
end

describe StatusNotification, "#notify with a daily user" do
  describe 'last notified less than a day ago' do
    it 'should not send an email' do
      ActionMailer::Base.deliveries.clear
      @user = mock_model(User)
      @status_notification = mock_model(StatusNotification, :user => @user)
      @status_notification.should_receive(:option).and_return('daily')
      @status_notification.should_receive(:last_updated_at).and_return(Time.now)
      @user.stub!(:status_notification).and_return(@status_notification)
      User.should_receive(:active).and_return([@user])

      StatusNotification.notify
      ActionMailer::Base.deliveries.should be_empty
    end
  end

  describe 'last notified over a day ago' do
    before(:each) do
      @time = 25.hours.ago
      
      ActionMailer::Base.deliveries.clear
      @user = mock_model(User)
      @status_notification = mock_model(StatusNotification, :user => @user)
      @status_notification.stub!(:option).and_return('daily')
      @status_notification.stub!(:last_updated_at).and_return(@time)
      @user.stub!(:status_notification).and_return(@status_notification)
      User.stub!(:active).and_return([@user])
      Status.stub!(:since).with(@status_notification.last_updated_at).and_return([])
      StatusMailer.stub!(:deliver_delayed_notification)
    end
    
    it 'should find all the statuses added since the last notification' do
      Status.should_receive(:since).with(@status_notification.last_updated_at).and_return([])
      StatusNotification.notify
    end

    it 'should send a digest email of the notifications' do
      StatusMailer.should_receive(:deliver_delayed_notification).with(@user, [])
      StatusNotification.notify
    end
  end
end
