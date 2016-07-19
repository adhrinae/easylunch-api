class CreateMealMeetUps < ActiveRecord::Migration
  def change
    create_table :meal_meet_ups do |t|
      t.integer :total_price
      t.integer :messenger_code
      t.string :messenger_room_id
      t.integer :admin_id
      t.integer :meetup_status

      t.timestamps null: false
    end
    add_foreign_key :meal_meet_ups, :users, column: :admin_id
    add_foreign_key :meal_meet_ups, :code_tables, column: :messenger_code
    add_foreign_key :meal_meet_ups, :code_tables, column: :meetup_status
  end
end
