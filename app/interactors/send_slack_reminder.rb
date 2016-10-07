class SendSlackReminder
  include Interactor

  def call
    notify = Slack::Notifier.new ENV["SLACK_WEBHOOK"], channel: '#announcements', username: 'clock-tower'
    message =  "HELLO GOAT"
    notify.ping message
  end

end
