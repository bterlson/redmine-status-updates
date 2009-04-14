class StatusNotification < ActiveRecord::Base
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
end
