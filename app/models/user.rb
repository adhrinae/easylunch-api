# User model
class User < ActiveRecord::Base
  has_many :meal_meet_ups, foreign_key: 'admin_id'
  has_many :meal_logs
  has_many :user_messengers

  # 새로운 맴버 등록시 필요한 일련의 과정들
  def self.init_member(member_uid, meetup, messenger_code, task_code)
    user = User.create(service_uid: member_uid)
    user_log = MealLog.create(user_id: user.id)
    UserMessenger.create(user_id: user.id,
                         messenger_code: messenger_code)
    MealMeetUpTask.create(meal_log_id: user_log.id,
                          meal_meet_up_id: meetup.id,
                          task_status: task_code)
    user # 바로 user_id를 사용가능하도록 return
  end
end
