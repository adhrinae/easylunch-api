# User model
class User < ActiveRecord::Base
  has_many :meal_meet_ups, foreign_key: 'admin_id'
  has_many :meal_logs
  has_many :user_messengers

  # 새로운 맴버 등록시 필요한 일련의 과정들
  def self.init_member(member_uid, meetup, messenger_code, task_code)
    user = find_by(service_uid: member_uid)
    if user.nil?
      result = enroll_new_user(member_uid, meetup, messenger_code, task_code)
    elsif user && user.find_enrolled_meetup(meetup.id).nil?
      result = enroll_exist_user(user, meetup, task_code)
    end
    result # Admin 등록을 위해 user정보가 리턴되어야 함
  end

  def self.delete_member(member_uid, meetup)
    user = find_by(service_uid: member_uid)
    target_log = user.find_enrolled_meetup(meetup.id)
    target_log.destroy
  end

  # DB에 기록되어있지 않은 맴버를 새로 생성
  def self.enroll_new_user(member_uid, meetup, messenger_code, task_code)
    user = User.create(service_uid: member_uid)
    user_log = MealLog.create(user_id: user.id)
    UserMessenger.create(user_id: user.id, messenger_code: messenger_code)
    MealMeetUpTask.create(meal_log_id: user_log.id,
                          meal_meet_up_id: meetup.id,
                          task_status: task_code)
    user
  end

  # DB에 등록된 적 있는 맴버가 새로운 MeetUp에 등록되는 경우
  def self.enroll_exist_user(user, meetup, task_code)
    user_log = MealLog.create(user_id: user.id)
    MealMeetUpTask.create(meal_log_id: user_log.id,
                          meal_meet_up_id: meetup.id,
                          task_status: task_code)
    user
  end

  def self.update_menu(meetup, user_info = {})
    user = find_by(service_uid: user_info[:member_id])
    user_log = user.find_enrolled_meetup(meetup.id) # 해당 MeetUp에 속하는 MealLog
    user_log.update(price: user_info[:price].to_i) if user_log.price.nil?
    user_log.update(menu_name: user_info[:menu])
    user_log
  end

  def self.update_task_status(meetup, user_info = {})
    task_code = CodeTable.find_task_status(user_info[:status]).id
    user = User.find_by(service_uid: user_info[:member_id])
    task = user.find_enrolled_meetup(meetup.id).meal_meet_up_task
    task.update(task_status: task_code)
    task.check_completed
    task
  end

  # 해당 유저가 MeetUp에 등록되어있는지 검사. 만약 유저 정보 자체가 없으면 false 리턴
  def self.enrolled_user?(user_id, meetup)
    user = find_by(service_uid: user_id)
    return false if user.nil?
    !user.find_enrolled_meetup(meetup.id).nil?
  end

  # 해당 user의 MeetUp등록 여부를 찾기 위해 Log > Task 연결하여 검색
  def find_enrolled_meetup(meetup_id)
    meal_logs.joins(:meal_meet_up_task).find_by(meal_meet_up_tasks:
                                              { meal_meet_up_id: meetup_id })
  end
end
