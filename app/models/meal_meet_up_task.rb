# Meal Meet Up Task model
class MealMeetUpTask < ActiveRecord::Base
  belongs_to :meal_meet_up
  belongs_to :meal_log
end
