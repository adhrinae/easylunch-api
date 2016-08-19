class ChangeMealMeetUp < ActiveRecord::Migration
  def change
    add_column :meal_meet_ups, :pay_type, :string
  end
end
