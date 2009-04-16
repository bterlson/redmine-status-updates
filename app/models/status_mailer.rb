class StatusMailer < Mailer
  def realtime_notification(status)
    recipients status.recipients
    subject "Status Update"
    body :author => status.user, :message => status.message
  end

  def delayed_notification(user, statuses)
    recipients [user.mail]
    subject "Status Update Digest"
    last_update = user.status_notification.last_updated_at
    body :statuses => statuses, :last_updated_at => last_update
  end
end
