class CreateMealLogs < ActiveRecord::Migration
  def change
    create_table :meal_logs do |t|
      t.references :user
      t.string :menu_name
      t.integer :price
      t.datetime :meal_time

      t.timestamps null: false
    end
    add_index :meal_logs, :user_id
  end
end
