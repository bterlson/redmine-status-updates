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
  before(:each) do
    Status.stub!(:visible_to_user).and_return(Status)
  end
  
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

describe Status, "#recipients" do
  it 'should include all members of the project with the "realtime" option' do
    project = mock_model(Project)
    project.stub!(:members).and_return do
      returning [] do |members|
        members << mock_model(Member, :user => mock_model(User, :mail => 'user1@example.com', :realtime_status_notification? => true ))
        members << mock_model(Member, :user => mock_model(User, :mail => 'user2@example.com', :realtime_status_notification? => true ))
      end
    end

    status = Status.new
    status.project = project

    status.recipients.should include('user1@example.com')
    status.recipients.should include('user2@example.com')
  end

  it 'should not include members are not "realtime" notified' do
    project = mock_model(Project)
    project.stub!(:members).and_return do
      returning [] do |members|
        members << mock_model(Member, :user => mock_model(User, :mail => 'user1@example.com', :realtime_status_notification? => true ))
        members << mock_model(Member, :user => mock_model(User, :mail => 'user2@example.com', :realtime_status_notification? => false ))
      end
    end

    status = Status.new
    status.project = project

    status.recipients.should_not include('user2@example.com')
  end

  it 'should return an empty array for projects without members' do
    project = mock_model(Project)
    project.stub!(:members).and_return([])
    status = Status.new
    status.project = project

    status.recipients.should eql([])
  end
end

describe Status, "recent_updates_for with a project" do
  before(:each) do
    @project = mock_model(Project)
    Status.stub!(:visible_to_user).and_return(Status)
    Status.stub!(:recent).and_return(Status)
    Status.stub!(:by_date).and_return(Status)
    Status.stub!(:for_project).and_return(Status)
  end
  
  it 'should get up to 100 updates' do
    Status.should_receive(:recent).with(100).and_return(Status)
    Status.recent_updates_for(@project)
  end

  it 'should order the updated by date' do
    Status.should_receive(:by_date).and_return(Status)
    Status.recent_updates_for(@project)
  end

  it 'should get updates only for the project' do
    Status.should_receive(:for_project).and_return(Status)
    Status.recent_updates_for(@project)
  end

  it 'should restrict the user to their own projects' do
    Status.should_receive(:visible_to_user).with(User.current, @project).and_return(Status)
    Status.recent_updates_for(@project)
  end
end

describe Status, "recent_updates_for without a project" do
  before(:each) do
    Status.stub!(:visible_to_user).and_return(Status)
    Status.stub!(:recent).and_return(Status)
    Status.stub!(:by_date).and_return(Status)
  end
  
  it 'should get up to 100 updates' do
    Status.should_receive(:recent).with(100).and_return(Status)
    Status.recent_updates_for(nil)
  end

  it 'should order the updated by date' do
    Status.should_receive(:by_date).and_return(Status)
    Status.recent_updates_for(nil)
  end

  it 'should restrict the user to their own projects' do
    Status.should_receive(:visible_to_user).with(User.current, nil).and_return(Status)
    Status.recent_updates_for(@project)
  end
end

describe Status, "tagged_with with a project" do
  before(:each) do
    @project = mock_model(Project)
    @tag = 'testing'
    Status.stub!(:visible_to_user).and_return(Status)
    Status.stub!(:recent).and_return(Status)
    Status.stub!(:by_date).and_return(Status)
    Status.stub!(:for_project).and_return(Status)
    Status.stub!(:tagged_with).and_return(Status)
  end
  
  it 'should get up to 100 updates' do
    Status.should_receive(:recent).with(100).and_return(Status)
    Status.recently_tagged_with(@tag, @project)
  end

  it 'should order the updated by date' do
    Status.should_receive(:by_date).and_return(Status)
    Status.recently_tagged_with(@tag, @project)
  end

  it 'should get updates only for the project' do
    Status.should_receive(:for_project).and_return(Status)
    Status.recently_tagged_with(@tag, @project)
  end

  it 'should get updates matching the tag' do
    Status.should_receive(:tagged_with).with(@tag).and_return(Status)
    Status.recently_tagged_with(@tag, @project)
  end

  it 'should restrict the user to their own projects' do
    Status.should_receive(:visible_to_user).with(User.current, @project).and_return(Status)
    Status.recently_tagged_with(@tag, @project)
  end
end

describe Status, "tagged_with without a project" do
  before(:each) do
    @tag = 'testing'
    Status.stub!(:visible_to_user).and_return(Status)
    Status.stub!(:recent).and_return(Status)
    Status.stub!(:by_date).and_return(Status)
    Status.stub!(:tagged_with).with(@tag).and_return(Status)
  end
  
  it 'should get up to 100 updates' do
    Status.should_receive(:recent).with(100).and_return(Status)
    Status.recently_tagged_with(@tag, nil)
  end

  it 'should order the updated by date' do
    Status.should_receive(:by_date).and_return(Status)
    Status.recently_tagged_with(@tag, nil)
  end

  it 'should get updates matching the tag' do
    Status.should_receive(:tagged_with).with(@tag).and_return(Status)
    Status.recently_tagged_with(@tag, nil)
  end

  it 'should restrict the user to their own projects' do
    Status.should_receive(:visible_to_user).with(User.current, nil).and_return(Status)
    Status.recently_tagged_with(@tag, nil)
  end
end

describe Status, "#search without a project" do
  before(:each) do
    @term = 'testing'
    Status.stub!(:visible_to_user).and_return(Status)
    Status.stub!(:recent).and_return(Status)
    Status.stub!(:by_date).and_return(Status)
    Status.stub!(:with_message_containing).and_return(Status)
  end
  
  it 'should get up to 100 updates' do
    Status.should_receive(:recent).with(100).and_return(Status)
    Status.search(@term, nil)
  end

  it 'should order the updated by date' do
    Status.should_receive(:by_date).and_return(Status)
    Status.search(@term, nil)
  end

  it 'should get updates matching the term' do
    Status.should_receive(:with_message_containing).with(@term).and_return(Status)
    Status.search(@term, nil)
  end

  it 'should restrict the user to their own projects' do
    Status.should_receive(:visible_to_user).with(User.current, nil).and_return(Status)
    Status.search(@term, nil)
  end
end

describe Status, "#search with a project" do
  before(:each) do
    @term = 'testing'
    @project = mock_model(Project)
    Status.stub!(:visible_to_user).and_return(Status)
    Status.stub!(:recent).and_return(Status)
    Status.stub!(:by_date).and_return(Status)
    Status.stub!(:with_message_containing).and_return(Status)
    Status.stub!(:for_project).and_return(Status)
  end
  
  it 'should get up to 100 updates' do
    Status.should_receive(:recent).with(100).and_return(Status)
    Status.search(@term, @project)
  end

  it 'should order the updated by date' do
    Status.should_receive(:by_date).and_return(Status)
    Status.search(@term, @project)
  end

  it 'should get updates matching the term' do
    Status.should_receive(:with_message_containing).with(@term).and_return(Status)
    Status.search(@term, @project)
  end

  it 'should restrict the user to their own projects' do
    Status.should_receive(:visible_to_user).with(User.current, @project).and_return(Status)
    Status.search(@term, @project)
  end

  it 'should get updates only for the project' do
    Status.should_receive(:for_project).and_return(Status)
    Status.search(@term, @project)
  end
end
