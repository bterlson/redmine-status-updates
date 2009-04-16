require File.dirname(__FILE__) + '/../spec_helper'

describe StatusMailer, '#realtime_notification' do
  before(:each) do
    ActionMailer::Base.deliveries.clear
    @author = mock_model(User, :name => 'Testing User')
    @status = mock_model(Status,
                         :message => 'This is a test, this is only a test',
                         :user => @author,
                         :recipients => ['test@example.com', 'user@example.org']
                         )
  end
  
  it 'should deliver one email' do
    StatusMailer.deliver_realtime_notification(@status)
    ActionMailer::Base.deliveries.size.should eql(1)
  end

  it 'should bcc all the recipients' do
    mail = StatusMailer.create_realtime_notification(@status)

    mail.bcc.should include('test@example.com')
    mail.bcc.should include('user@example.org')
  end

  it 'should have "Status Update" in the subject' do
    mail = StatusMailer.create_realtime_notification(@status)
    mail.subject.should include("Status Update")
  end

  it 'should have the Status author in the body' do
    mail = StatusMailer.create_realtime_notification(@status)
    mail.encoded.should include(@author.name)
  end

  it 'should have the Status message in the body' do
    mail = StatusMailer.create_realtime_notification(@status)
    mail.encoded.should include(@status.message)
  end
end

describe StatusMailer, '#delayed_notification' do
  include ApplicationHelper # format_time

  before(:each) do
    ActionMailer::Base.deliveries.clear
    @when = 1.hour.ago.utc
    @user = mock_model(User,
                       :name => 'Testing User',
                       :mail => 'test@example.com',
                       :pref => {},
                       :time_zone => nil,
                       :status_notification => mock_model(StatusNotification, :last_updated_at => @when))
    @author_1 = mock_model(User, :name => 'Testing Author 1')
    @author_2 = mock_model(User, :name => 'Testing Author 2')
    @author_3 = mock_model(User, :name => 'Testing Author 3')
    @statuses = [
                 Status.new({:user => @author_1, :message => 'This is the first status.'}),
                 Status.new({:user => @author_2, :message => 'This is the second status.'}),
                 Status.new({:user => @author_3, :message => 'This is the third status.'}),
                 Status.new({:user => @author_3, :message => 'I also posted a few more updates.'}),
                 Status.new({:user => @author_3, :message => 'Final update.'}),
                ]
    User.stub!(:current).and_return(@user)
  end
  
  it 'should deliver one email' do
    StatusMailer.deliver_delayed_notification(@user, @statuses)
    ActionMailer::Base.deliveries.size.should eql(1)
  end

  it 'should bcc the recipient' do
    mail = StatusMailer.create_delayed_notification(@user, @statuses)
    mail.bcc.should include(@user.mail)
  end

  it 'should have "Status Update Digest" in the subject' do
    mail = StatusMailer.create_delayed_notification(@user, @statuses)
    mail.subject.should include("Status Update Digest")
  end

  it 'should include the time of the last update in the body' do
    mail = StatusMailer.create_delayed_notification(@user, @statuses)
    mail.encoded.should include(format_time(@when))
  end

  it 'should not include a time if the user was never updated' do
    @user.should_receive(:status_notification).and_return(mock_model(StatusNotification, :last_updated_at => nil))
    StatusMailer.create_delayed_notification(@user, @statuses)
  end

  it 'should have each Status author in the body' do
    mail = StatusMailer.create_delayed_notification(@user, @statuses)
    @statuses.each do |status|
      mail.encoded.should include(status.user.name)
    end
  end

  it 'should have each Status message in the body' do
    mail = StatusMailer.create_delayed_notification(@user, @statuses)
    @statuses.each do |status|
      mail.encoded.should include(status.message)
    end
  end
end
