class StatusObserver < ActiveRecord::Observer
  observe :status

  def after_create(status)
    StatusMailer.deliver_realtime_notification(status)
  end
end
