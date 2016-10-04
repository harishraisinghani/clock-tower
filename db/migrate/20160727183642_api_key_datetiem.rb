class ApiKeyDatetiem < ActiveRecord::Migration
  def change
    change_column :api_keys, :revoked_on, :datetime
    change_column :api_keys, :last_accessed, :datetime
  end
end
