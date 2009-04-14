require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it 'should have a status_notification association' do
    User.should have_association(:status_notification, :has_one)
  end
end
