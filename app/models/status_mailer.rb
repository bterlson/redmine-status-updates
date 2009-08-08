class StatusMailer < Mailer
  def realtime_notification(status)
    recipients status.recipients
    subject "Status Update"
    content_type    "multipart/alternative"

    part :content_type => "text/html",
      :body => render_message("realtime_notification.text.html.erb", :author => status.user, :message => status.message)

    part "text/plain" do |p|
      p.body = render_message("realtime_notification.text.plain.erb", :author => status.user, :message => status.message)
      p.transfer_encoding = "base64"
    end

  end

  def delayed_notification(user, statuses)
    recipients [user.mail]
    subject "Status Update Digest"
    content_type    "multipart/alternative"

    last_update = user.status_notification.last_updated_at

    part :content_type => "text/html",
      :body => render_message("delayed_notification.text.html.erb", :statuses => statuses, :last_updated_at => last_update)

    part "text/plain" do |p|
      p.body = render_message("delayed_notification.text.plain.erb", :statuses => statuses, :last_updated_at => last_update)
      p.transfer_encoding = "base64"
    end
  end
end
