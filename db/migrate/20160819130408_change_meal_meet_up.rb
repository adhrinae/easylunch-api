class ChangeMealMeetUp < ActiveRecord::Migration
  def change
    add_column :meal_meet_ups, :paying_status, :integer
  end
end
