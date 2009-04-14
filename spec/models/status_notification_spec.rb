require File.dirname(__FILE__) + '/../spec_helper'

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
