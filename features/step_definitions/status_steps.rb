Given /^I am logged in$/ do
  @current_user = User.make
  User.stubs(:current).returns(@current_user)
end

Given /^I am on the Status page$/ do
  unless @project
    @project = Project.make
  end
  
  visit url_for(:controller => 'statuses', :action => 'index', :id => @project.id)
end

Given /^there are "(.*)" statuses$/ do |number|
  number.to_i.times do
    Status.make(:project => @project)
  end
end
