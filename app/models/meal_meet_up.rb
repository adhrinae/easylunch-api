# Meal Meet Up model
class MealMeetUp < ActiveRecord::Base
  has_many :meal_meet_up_logs
  has_many :meal_meet_up_tasks
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  belongs_to :messenger, class_name: 'CodeTable', foreign_key: 'messenger_code'
  belongs_to :status,    class_name: 'CodeTable', foreign_key: 'meetup_status'
end
