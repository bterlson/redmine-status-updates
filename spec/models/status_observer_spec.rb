require File.dirname(__FILE__) + '/../spec_helper'

describe StatusObserver do
  it 'should observe status' do
    ActiveRecord::Base.observers.should include(:status_observer)
  end
end

describe StatusObserver, '#after_create' do
  it 'should send a realtime notification' do
    status = Status.new
    StatusMailer.should_receive(:deliver_realtime_notification)
    StatusObserver.instance.after_create(status)
  end
end
