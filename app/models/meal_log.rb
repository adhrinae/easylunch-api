# Meal Log model
class MealLog < ActiveRecord::Base
  has_many :meal_meet_up_tasks
  belongs_to :user
end
