class CreateMealMeetUpTasks < ActiveRecord::Migration
  def change
    create_table :meal_meet_up_tasks do |t|
      t.references :meal_log
      t.references :meal_meet_up
      t.integer :task_status

      t.timestamps null: false
    end
    add_index :meal_meet_up_tasks, :meal_log_id
    add_index :meal_meet_up_tasks, :meal_meet_up_id
    add_foreign_key :meal_meet_up_tasks, :code_tables, column: :task_status
  end
end
