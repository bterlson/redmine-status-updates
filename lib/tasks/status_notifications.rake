namespace :redmine_status do
  desc <<-END_DESC
Send status notifications to users with a delayed notification perference.

Example:
  rake redmine_status:delayed_notifications RAILS_ENV="production"
END_DESC

  task :delayed_notifications => :environment do
    StatusNotification.notify
  end
end
