# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

### Setting slack notification job for 1 day before end of Statement Period at 9am

# periods = StatementPeriod.all()

# periods.each do |period|
#   unlocked_statements = Statement.where(locked_at: nil)
#   unlocked_statements.each do |statement|
#     person = User.find(statement.user_id)
#     notify_day = period.to.to_i - 1
#     every "0 9 #{notify_day} * *" do
#       runner "person.send_slack_reminder"
#     end
#   end
# end

###For testing purposes only

# every 2.minutes do
#   runner "SendSlackReminder.call()"
# end
###


