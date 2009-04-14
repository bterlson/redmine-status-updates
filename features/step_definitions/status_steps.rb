Before do
  Sham.reset
  Setting.stubs(:gravatar_enabled?).returns(true)
end

def strip_hash_from_hashtag(hashtag)
  hashtag.sub(/^#/,'')
end

Given /^I am logged in$/ do
  @current_user = User.make
  User.stubs(:current).returns(@current_user)
end

Given /^I am a member of a project$/ do
  @project = make_project_with_enabled_modules
  Member.make(:project => @project, :user => @current_user)
end

Given /^I am a member of a project named "(.*)"$/ do |named|
  @project = make_project_with_enabled_modules :name => named
  Member.make(:project => @project, :user => @current_user)
end

Given /^I am on the Status page for the project$/ do
  unless @project
    @project = make_project_with_enabled_modules
  end
  
  visit url_for(:controller => 'statuses', :action => 'index', :id => @project.id)
end

Given /^I am on the Status page$/ do
  visit url_for(:controller => 'statuses', :action => 'index')
end

Given /^I am on the Homepage$/ do
  visit url_for(:controller => 'welcome')
end

Given /^I am on the Hashtag page for "(.*)" on the project$/ do |hashtag|
  unless @project
    @project = make_project_with_enabled_modules
  end
  
  visit url_for(:controller => 'statuses', :action => 'tagged', :id => @project.id, :tag => strip_hash_from_hashtag(hashtag))
end

Given /^I am on the Hashtag cloud page for the project$/ do
  unless @project
    @project = make_project_with_enabled_modules
  end
  
  visit url_for(:controller => 'statuses', :action => 'tag_cloud', :id => @project.id)
end


Given /^there are "(.*)" statuses$/ do |number|
  number.to_i.times do
    Status.make(:project => @project)
  end
end

Given /^there are "(.*)" statuses with a Hashtag of "(.*)"$/ do |number, hashtag|
  number.to_i.times do
    Status.make(:project => @project, :message => "Test " + hashtag)
  end
end

Given /^there are "(.*)" statuses for another project$/ do |number|
  @project_two = make_project_with_enabled_modules

  number.to_i.times do
    Status.make(:project => @project_two)
  end
end

Then /^my preference should be "(.*)"$/ do |value|
  @current_user.status_notification.should_not be_nil
  @current_user.status_notification.option.should eql(value)
end

Then /^I should see "(.*)" updates$/ do |count|
  response.should have_tag("dd.status_message", :count => count.to_i)
end

Then /^I should see "(.*)" Gravatar images$/ do |count|
  response.should have_tag("img.gravatar", :count => count.to_i)
end

Then /^I am on the "(.*)" Hashtag page for the project$/ do |hashtag|
  response.should render_template('tagged')
end

Then /^I am on the "Status" page$/ do
  response.should render_template('index')
end

Then /^I am on the "Notification Preferences" page$/ do
  response.should be_success
  response.should render_template('status_notifications/edit')
end


Then /^I should see "(.*)" items in the cloud$/ do |count|
  response.should have_tag("div#tag_cloud") do
    with_tag("a[class^=bank]", :count => count.to_i)
  end
end

Then /^I should see a "top" menu item called "Status updates"$/ do
  response.should have_tag("div#top-menu") do
    with_tag("a", "Status updates")
  end
end

Then /^I should see the project name by each update$/ do
  response.should have_tag("dt.status_user") do
    with_tag("a", @project.name)
  end
end

Then /^I should see a "New Message" form$/ do
  response.should have_tag("form#status")
end

Then /^I should be able to select which project to post to$/ do
  response.should have_tag("select#status_project_id")
end

Then /^I should see a form for changing my preference$/ do
  response.should have_tag("form#notification_preference") do
    with_tag("select#status_notification_option")
  end
end
