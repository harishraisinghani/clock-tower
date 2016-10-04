class TimeEntryRate < ActiveRecord::Migration
  def change
    add_column :time_entries, :source_rate_id, :integer, null: true, index: true
  end
end
