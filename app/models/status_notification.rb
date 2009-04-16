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
      if user.status_notification
        case user.status_notification.option
        when 'hourly'
          if user.status_notification.last_updated_at <= 1.hour.ago
            # TODO: send
            StatusMailer.deliver_delayed_notification(user,
                                                      Status.since(user.status_notification.last_updated_at))
          end
        else
          # no-op
        end
      end
    end
  end
end
