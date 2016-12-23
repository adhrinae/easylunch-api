# Meal Meet Up Task model
class MealMeetUpTask < ActiveRecord::Base
  belongs_to :meal_meet_up
  belongs_to :meal_log
  belongs_to :status, class_name: 'CodeTable', foreign_key: 'task_status'

  def check_completed
    result = meal_meet_up.meal_meet_up_tasks.all? do |task|
      task.status.value == 'paid'
    end
    completed_code = CodeTable.find_meetup_status('completed')
    meal_meet_up.update(status: completed_code) if result
  end
end
