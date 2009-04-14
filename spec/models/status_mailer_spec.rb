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
