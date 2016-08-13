# Meal Log model
class MealLog < ActiveRecord::Base
  has_one :meal_meet_up_task
  belongs_to :user
end
