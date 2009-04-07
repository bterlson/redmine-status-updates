require File.dirname(__FILE__) + '/../spec_helper'

describe Status, "#has_hashtag?" do
  it 'should be false when there is no message' do
    Status.new.has_hashtag?.should be_false
  end
  
  it 'should be false when 0 hashtags are present' do
    Status.new(:message => 'Test status').has_hashtag?.should be_false
  end

  it 'should be true when 1 hashtag is present' do
    Status.new(:message => 'Test with hashtag #tagged').
      has_hashtag?.should be_true
  end

  it 'should be true when more than 1 hashtag is present' do
    Status.new(:message => 'Test with hashtag #tagged #business #redmine #plugin').
      has_hashtag?.should be_true
  end
end

describe Status, "#tag_cloud" do
  describe 'should return an object with' do
    it 'the name of the tag'

    it 'the count of the tag'

  end
end
