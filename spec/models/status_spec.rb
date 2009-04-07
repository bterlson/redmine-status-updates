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
  def stub_some_tags(&block)
    Status.should_receive(:tagged_with).with('').and_return do
      statuses = []
      statuses << mock_model(Status, :message => "Message #test")
      statuses << mock_model(Status, :message => "Message #test #rspec")
      statuses << mock_model(Status, :message => "Message #test #rspec")
      statuses << mock_model(Status, :message => "Message #test #rails")
      statuses << mock_model(Status, :message => "Message #test #rails")
      statuses << mock_model(Status, :message => "Message #test #rails ")
      statuses << yield if block_given?
      statuses.flatten
    end
  end
  
  it 'should return a hash of tags and their count' do
    stub_some_tags

    cloud = Status.tag_cloud
    cloud.should respond_to(:keys)
    cloud.should respond_to(:values)
  end

  it 'should have the correct counts' do
    stub_some_tags

    cloud = Status.tag_cloud
    cloud['test'].should eql(6)
    cloud['rspec'].should eql(2)
    cloud['rails'].should eql(3)
  end

  it 'should merge tags with different cases' do
    stub_some_tags do
      [
       mock_model(Status, :message => 'Message #TEST'),
       mock_model(Status, :message => 'Message #tEsT'),
       mock_model(Status, :message => 'Message #Test')
      ]
    end

    cloud = Status.tag_cloud
    cloud['test'].should eql(9)
    cloud.should_not have_key('TEST')
    cloud.should_not have_key('tEsT')
    cloud.should_not have_key('Test')
  end
end
