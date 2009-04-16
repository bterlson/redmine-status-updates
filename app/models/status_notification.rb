class StatusNotification < ActiveRecord::Base
  belongs_to :user

  VALID_OPTIONS = {
    :realtime => 'Realtime',
    :hourly => 'Hourly',
    :eight_hours => '8 Hours',
    :daily => 'Daily'
  }

  validates_inclusion_of :option, :in => VALID_OPTIONS.stringify_keys.keys, :allow_blank => true, :allow_nil => true

  
  def option_to_string
    VALID_OPTIONS[self.option.to_sym] unless self.option.blank?
  end

  def self.notify
    User.active.each do |user|
      if user.status_notification && should_notify?(user)
        send_delayed_notification(user)
      end
    end
  end

  private

  # Should the user be notified?
  def self.should_notify?(user)
    case user.status_notification.option
    when 'hourly'
      return user.status_notification.last_updated_at <= 1.hour.ago
    when 'eight_hours'
      return user.status_notification.last_updated_at <= 8.hours.ago
    when 'daily'
      return user.status_notification.last_updated_at <= 24.hours.ago
    else
      # no-op: realtime or blank
    end
    return false
  end
  
  def self.send_delayed_notification(user)
    statuses = Status.since(user.status_notification.last_updated_at)
    StatusMailer.deliver_delayed_notification(user, statuses)
  end
end
