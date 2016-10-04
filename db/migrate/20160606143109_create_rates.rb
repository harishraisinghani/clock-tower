class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.references :project, :task, :user
      t.decimal :rate,  precision: 5, scale: 2, null: false
      t.string :note, null: false
      t.timestamps null: false
    end
  end
end
