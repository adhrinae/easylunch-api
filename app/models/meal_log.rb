# Meal Log model
class MealLog < ActiveRecord::Base
  has_one :meal_meet_up_task, dependent: :destroy
  belongs_to :user
end
