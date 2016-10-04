class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :key, null: false
      t.references :user, null: false
      t.string :note, default: "", null: false
      t.date :last_accessed
      t.string :last_ip, default: "", null: false
      t.date :revoked_on

      t.timestamps null: false
    end
  end
end
