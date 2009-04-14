class StatusMailer < Mailer
  def realtime_notification(status)
    recipients status.recipients
    subject "Status Update"
    body :author => status.user, :message => status.message
  end
end
