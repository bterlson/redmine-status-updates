class StatusNotification < ActiveRecord::Base
  VALID_OPTIONS = {
    :realtime => 'Realtime',
    :hourly => 'Hourly',
    :eight_hours => '8 Hours',
    :daily => 'daily'
  }
end
