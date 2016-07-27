class CreateMealMeetUpLogs < ActiveRecord::Migration
  def change
    create_table :meal_meet_up_logs do |t|
      t.references :meal_meet_up
      t.string :description

      t.timestamps null: false
    end
    add_index :meal_meet_up_logs, :meal_meet_up_id
  end
end
