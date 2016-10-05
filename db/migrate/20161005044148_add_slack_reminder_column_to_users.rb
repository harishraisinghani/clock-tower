class AddSlackReminderColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slack_reminder, :boolean
  end
end
