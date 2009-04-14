require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it 'should have a status_notification association' do
    User.should have_association(:status_notification, :has_one)
  end
end

describe User, "#realtime_status_notification?" do
  it 'should be true if status_notification is "realtime"' do
    notification = mock_model(StatusNotification, :option => 'realtime')
    user = User.new
    user.should_receive(:status_notification).at_least(:once).and_return(notification)

    user.realtime_status_notification?.should be_true
  end

  it 'should be false if status_notification is empty' do
    user = User.new
    user.should_receive(:status_notification).at_least(:once).and_return(nil)

    user.realtime_status_notification?.should be_false
  end

  it 'should be false if status_notification is not "realtime"' do
    notification = mock_model(StatusNotification, :option => 'daily')
    user = User.new
    user.should_receive(:status_notification).at_least(:once).and_return(notification)

    user.realtime_status_notification?.should be_false
  end
end
