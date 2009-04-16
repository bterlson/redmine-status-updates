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
      return past_time_delay?(user, 1)
    when 'eight_hours'
      return past_time_delay?(user, 8)
    when 'daily'
      return past_time_delay?(user, 24)
    else
      # no-op: realtime or blank
    end
    return false
  end

  def self.past_time_delay?(user, number_of_hours)
    if last_update = user.status_notification.last_updated_at
      return last_update <= number_of_hours.hours.ago
    else
      # Never notified, do it now
      return true
    end
  end
  
  def self.send_delayed_notification(user)
    if !user.status_notification.last_updated_at.blank?
      statuses = Status.since(user.status_notification.last_updated_at)
    else
      statuses = Status.find(:all)
    end

    unless statuses.empty?
      StatusMailer.deliver_delayed_notification(user, statuses)
    end
  end
end
