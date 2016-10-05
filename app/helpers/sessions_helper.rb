module SessionsHelper
  
  def slack_reminder
    notify = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#announcements', username: 'clock-tower'
    notify.ping "Reminder to review your statement"
  end
end
